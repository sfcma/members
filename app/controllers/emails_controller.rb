class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy, :send_email]
  before_action :authenticate_user!

  include PerformanceSetsHelper
  include EmailsHelper

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    @performance_set = @email.performance_set
    @instruments = @email.instruments.gsub(/[\"\]\[]/,"").split(",").reject!(&:blank?) || []
    @instruments = @instruments.map(&:strip)
    @status_id = @email.status
    @member_sets = MemberSet.filtered_by_criteria(@performance_set.id, @status_id, @instruments)
    @instrument_groups = organize_members_by_instrument(@performance_set, @member_sets)
  end

  def edit
    @performance_sets = emailable_performance_sets
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []
    unless @email.sent_at.nil?
      redirect_to emails_url, notice: 'Cannot edit emails that have already been sent!'
    end
  end

  # GET /emails/new
  def new
    @performance_sets = emailable_performance_sets
    if params[:performance_set_id].to_i > 0
      @performance_set_id = params[:performance_set_id].to_i
    end
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []
    @email = Email.new
  end

  # POST /emails
  # POST /emails.json
  def create
    @performance_sets = emailable_performance_sets
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    @performance_sets = PerformanceSet.emailable
    @statuses_for_email = Email.statuses_for_emails
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email successfully updated – not yet sent.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Cannot delete emails.' }
      format.json { head :no_content }
    end
  end

  def send_email
    Rails.logger.info "Sending email"
    unless @email.sent_at.nil?
      respond_to do |format|
        format.html { redirect_to email_url(@email), notice: 'Cannot re-send email already sent.' }
        format.json { head :no_content }
      end
      return
    end
    unless params[:member_ids].present?
      respond_to do |format|
        format.html { redirect_to email_url(@email), notice: 'No members to send to.' }
        format.json { head :no_content }
      end
      return
    end

    members = Member.find(params[:member_ids].split(",").map{ |mi| mi.to_i })

    members.each do |member|
      begin
        Rails.logger.info "Sending email #{@email.id} to #{member.id}"
        member_insts = MemberInstrument.where(member_id: member.id)
        smi = SetMemberInstrument.where(member_instrument_id: member_insts.map(&:id), member_set_id: MemberSet.where(member_id: member.id, performance_set_id: @email.performance_set.id))
        if member.email_1.present?
          MemberMailer.standard_member_email(member, @email.email_title, @email.email_body, current_user, @email.id, member.id, @email.performance_set.extended_name, @email.instruments, @email.status, smi).deliver_now
        else
          Bugsnag.notify("No email address available for member: #{member.id}")
        end
        EmailLog.new(email_id: @email.id, member_id: member.id, created_at: Time.now).save
      rescue StandardError => e
        Bugsnag.notify(e)
      end
    end
    @email.update(sent_at: Time.now)
    respond_to do |format|
      format.html { redirect_to emails_url, notice: "Email successfully sent." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(
        :email_body,
        :email_title,
        :performance_set_id,
        :status,
        :user_id,
        :behalf_of_name,
        :behalf_of_email,
        :instruments => []
      )
    end
end
