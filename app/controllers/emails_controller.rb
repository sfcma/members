class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy, :send_email]
  before_action :authenticate_user!

  include PerformanceSetsHelper
  include EmailsHelper

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all.includes(:ensemble, :performance_set).order('sent_at DESC')
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    @performance_set = @email.performance_set
    @ensemble = @email.ensemble
    @instruments = @email.instruments.gsub(/[\"\]\[]/,"").split(",").reject!(&:blank?) || []
    @instruments = @instruments.map(&:strip)
    @status_id = @email.status
    if @performance_set
      @member_sets = MemberSet.filtered_by_criteria(@performance_set.id, @status_id, @instruments)
      @instrument_groups = organize_members_by_instrument(@member_sets)
    elsif @ensemble
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .where(ensemble_id: @ensemble.id)
        .map(&:id)
      @member_sets = MemberSet.where(performance_set_id: performance_set_ids, member_id: Member.played_with_ensemble_last_year(@ensemble.id))
      @instrument_groups = organize_members_by_instrument(@member_sets)
    else
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .map(&:id)
      @instrument_groups = { "(Any Instrument)" => MemberSet.where(performance_set_id: performance_set_ids, member_id: Member.played_with_any_ensemble_last_year) }
    end

  end

  def edit
    @performance_sets = emailable_performance_sets
    @ensembles = emailable_ensembles
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []
    unless @email.sent_at.nil?
      redirect_to emails_url, notice: 'Cannot edit emails that have already been sent!'
    end
  end

  # GET /emails/new
  def new
    @performance_sets = emailable_performance_sets
    @ensembles = emailable_ensembles
    if params[:performance_set_id].to_i > 0
      @performance_set_id = params[:performance_set_id].to_i
    end
    if params[:ensemble_id].to_i > 0
      @ensemble_id = params[:ensemble_id].to_i
    end
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []
    @email = Email.new
  end

  # POST /emails
  # POST /emails.json
  def create
    @performance_sets = emailable_performance_sets
    @ensembles = emailable_ensembles
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        if params[:files]
          params[:files].each { |file|
            if (a = Attachment.new(file: file)).save
              @email.attachments << a
            else
              flash.now[:error] = '<img height=40 src="https://cdn0.iconfinder.com/data/icons/shift-free/32/Error-128.png"> Unable to attach that file. <br> Please try a different file. <br><br>Attachments must be: PDF, Images, Excel, or Word Documents only, and must be under 5MB.'.html_safe
              format.html { render :edit }
            end
          }
        end
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
    @performance_sets = emailable_performance_sets
    @ensembles = emailable_ensembles
    @statuses_for_email = Email.statuses_for_emails
    @instruments = []

    if email_params.has_key?(:ensemble_id) && !email_params.has_key?(:performance_set_id)
      @email.update(performance_set_id: nil)
    elsif !email_params.has_key?(:ensemble_id) && email_params.has_key?(:performance_set_id)
      @email.update(ensemble_id: nil)
    end

    respond_to do |format|
      if @email.update(email_params)
        if params[:files]
          params[:files].each { |file|
            if (a = Attachment.new(file: file)).save
              @email.attachments << a
            else
              flash.now[:error] = '<img height=40 src="https://cdn0.iconfinder.com/data/icons/shift-free/32/Error-128.png"> Unable to attach that file. <br> Please try a different file. <br><br>Attachments must be: PDF, Images, Excel, or Word Documents only, and must be under 5MB.'.html_safe
              format.html { render :edit }
            end
          }
        end
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
    EmailJob.perform_async('email', @email, params[:member_ids], current_user)

    respond_to do |format|
      format.html { redirect_to emails_url, notice: "Email is being sent." }
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
        :ensemble_id,
        :status,
        :user_id,
        :behalf_of_name,
        :behalf_of_email,
        :files,
        :instruments => []
      )
    end
end
