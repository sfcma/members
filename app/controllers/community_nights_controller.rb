class CommunityNightsController < ApplicationController
  before_action :set_community_night, only: [:show, :edit, :update, :destroy, :roster, :check_instrument_limit]
  before_action :authenticate_user!, except: [:check_instrument_limit]
  include Instruments

  # GET /community_nights
  # GET /community_nights.json
  def index
    @community_nights = CommunityNight.all.order(start_datetime: :desc)
  end

  # GET /community_nights/1
  # GET /community_nights/1.json
  def show
  end

  # GET /community_nights/new
  def new
    @opt_in_messages = OptInMessage.all
    @community_night = CommunityNight.new
  end

  # GET /community_nights/1/edit
  def edit
    @opt_in_messages = OptInMessage.all
  end

  # POST /community_nights
  # POST /community_nights.json
  def create
    @community_night = CommunityNight.new(community_night_params)
    @opt_in_messages = OptInMessage.all
    respond_to do |format|
      if @community_night.save
        format.html { redirect_to @community_night, notice: 'Community night was successfully created.' }
        format.json { render :show, status: :created, location: @community_night }
      else
        format.html { render :new }
        format.json { render json: @community_night.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /community_nights/1
  # PATCH/PUT /community_nights/1.json
  def update
    @opt_in_messages = OptInMessage.all
    respond_to do |format|
      if @community_night.update(community_night_params)
        format.html { redirect_to @community_night, notice: 'Community night was successfully updated.' }
        format.json { render :show, status: :ok, location: @community_night }
      else
        format.html { render :edit }
        format.json { render json: @community_night.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /community_nights/1
  # DELETE /community_nights/1.json
  def destroy
    @community_night.destroy
    respond_to do |format|
      format.html { redirect_to community_nights_url, notice: 'Community night was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def roster
  end

  def check_instrument_limit
    instrument = params[:instrument]
    psi = CommunityNightInstrument.find_by("community_night_id=#{@community_night.id} and lower(instrument)=?", instrument.downcase)
    if psi
      psi_limit = psi.limit || 10000
      over_limit = psi_limit > 0 && MemberCommunityNight.get_count(@community_night.id, [instrument]).count >= (psi_limit)
    else
      psi_limit = 10000
      over_limit = false
    end

    if over_limit
      respond_to do |format|
        format.json { render json: { status: "over_limit" } }
      end
    else
      at_standby = MemberCommunityNight.get_count(@community_night.id, [instrument]).count >= psi_limit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community_night
      @community_night = CommunityNight.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_night_params
      params.require(:community_night).permit(
        :start_datetime,
        :end_datetime,
        :type,
        :name,
        :description,
        community_night_instruments_attributes: [
          :id,
          :community_night_id,
          :instrument,
          :limit,
          :available_to_opt_in
        ]
        )
    end


end
