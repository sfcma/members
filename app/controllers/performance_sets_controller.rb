class PerformanceSetsController < ApplicationController
  before_action :set_performance_set, only: [:show, :edit, :update, :destroy, :rehearsal_dates, :roster, :email_roster, :check_instrument_limit, :free_members]
  before_action :authenticate_user!, except: [:rehearsal_dates, :check_instrument_limit]
  include Instruments

  # GET /performance_sets
  # GET /performance_sets.json
  def index
    @performance_sets = PerformanceSet.all
  end

  # GET /performance_sets/1
  # GET /performance_sets/1.json
  def show
    @audit_string = helpers.generate_audit_array(@performance_set)
  end

  # GET /performance_sets/new
  def new
    unless current_user.global_admin?
      redirect_to performance_sets_url, notice: 'You do not have permissions to add performance sets' and return
    end
    @opt_in_messages = OptInMessage.all
    @performance_set = PerformanceSet.new
    @ensembles = Ensemble.all
  end

  # GET /performance_sets/1/edit
  def edit
    unless current_user.global_admin?
      redirect_to @performance_set, notice: 'You do not have permissions to edit performance sets' and return
    end
    @opt_in_messages = OptInMessage.all
    @ensembles = Ensemble.all
  end

  # POST /performance_sets
  # POST /performance_sets.json
  def create
    unless current_user.global_admin?
      redirect_to performance_sets_url, notice: 'You do not have permissions to add performance sets' and return
    end
    @performance_set = PerformanceSet.new(performance_set_params)

    # @performance_set.start_date = performance_set_params.start_date.to_time.to_i
    # @performance_set.end_date = performance_set_params.end_date.to_time.to_i
    @opt_in_messages = OptInMessage.all
    @ensembles = Ensemble.all

    respond_to do |format|
      if @performance_set.save
        format.html { redirect_to @performance_set, notice: 'Performance set was successfully created.' }
        format.json { render :show, status: :created, location: @performance_set }
      else
        format.html { render :new }
        format.json { render json: @performance_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /performance_sets/1
  # PATCH/PUT /performance_sets/1.json
  def update
    unless current_user.global_admin?
      redirect_to @performance_set, notice: 'You do not have permissions to edit performance sets' and return
    end
    @opt_in_messages = OptInMessage.all
    @ensembles = Ensemble.all
    respond_to do |format|
      if @performance_set.update(performance_set_params)
        format.html { redirect_to @performance_set, notice: 'Performance set was successfully updated.' }
        format.json { render :show, status: :ok, location: @performance_set }
      else
        format.html { render :edit }
        format.json { render json: @performance_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /performance_sets/1
  # DELETE /performance_sets/1.json
  def destroy
    @performance_set.destroy
    respond_to do |format|
      format.html { redirect_to performance_sets_url, notice: 'Performance set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def rehearsal_dates
    rehearal_dates = @performance_set.performance_set_dates
    respond_to do |format|
      format.json { render json: rehearal_dates, status: :ok }
    end
  end

  def roster
    @member_email_statuses = Email.statuses_for_general_use
    @email_status = params[:e_status] || 2
    @email_status_name = @member_email_statuses[@email_status]
    @member_sets = MemberSet.filtered_by_criteria(@performance_set.id, @email_status)
  end

  def email_roster
    @members = []
    @member_sets = MemberSet.includes(:member).where(performance_set_id: @performance_set.id).to_a
    @member_sets.each do |ms|
      @members << ms.member
    end
  end

  def check_instrument_limit
    instrument = params[:instrument]
    psi = PerformanceSetInstrument.find_by("performance_set_id=#{@performance_set.id} and lower(instrument)=?", instrument.downcase)
    if psi
      psi_limit = psi.limit || 10000
      over_limit = psi_limit > 0 && MemberSet.filtered_by_criteria(@performance_set.id, 4, [instrument]).count >= (psi_limit + psi.standby_limit)
    else
      psi_limit = 10000
      over_limit = false
    end

    if over_limit
      respond_to do |format|
        format.json { render json: { status: "over_limit" } }
      end
    else
      at_standby = MemberSet.filtered_by_criteria(@performance_set.id, 4, [instrument]).count >= psi_limit
      if at_standby
        respond_to do |format|
          format.json { render json: { status: "standby_only" } }
        end
      else
        respond_to do |format|
          format.json { render json: { status:  "ok" } }
        end
      end
    end
  end

  def free_members
    # performance sets taking place during this set. want to exclude all
    # members playing in them
    perf_sets = PerformanceSet.where("start_date < '#{@performance_set.end_date}' and end_date > '#{@performance_set.start_date}'")
    members_in_ps = []
    perf_sets.each do |ps|
      members_in_ps = members_in_ps.concat MemberSet.filtered_by_criteria(ps.id, 4).map(&:member)
    end
    members_currently_playing = members_in_ps.map(&:id).uniq
    @members = Member.select('member_instruments.instrument, members.id, members.first_name, members.last_name, members.email_1').joins(:member_instruments).order('member_instruments.instrument').where(id: Member.played_with_any_ensemble_last_year.map(&:id) - members_currently_playing)
    @instrument_groups = {}

    @members = @members.each do |m|
      instrument = m.instrument
      @instrument_groups[instrument] ||= []
      if params[:email] == "true"
        @instrument_groups[instrument] << m.email_1
      else
        @instrument_groups[instrument] << "#{m.first_name} #{m.last_name}"
      end
    end
    @instrument_groups.sort_by { |e, v| Instruments.instruments.index(e) || Instruments.instruments.length }.to_h
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_performance_set
    @performance_set = PerformanceSet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def performance_set_params
    params.require(:performance_set).permit(
      :ensemble_id,
      :start_date,
      :description,
      :end_date,
      :opt_in_start_date,
      :opt_in_end_date,
      :name,
      :opt_in_message,
      performance_set_instruments_attributes: [
        :id,
        :performance_set_id,
        :instrument,
        :limit,
        :available_to_opt_in,
        :opt_in_message_type,
        :opt_in_message_id,
        :standby_limit
      ],
      performance_set_dates_attributes: [
        :id,
        :performance_set_id,
        :date
      ],
    )
  end
end
