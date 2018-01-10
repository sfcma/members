class CommunityNightInstrumentsController < ApplicationController
  before_action :set_community_night_instrument, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]

  # GET /community_night_instruments
  # GET /community_night_instruments.json
  def index
    if params[:include_conductor] == "true"
      include_conductor = true
    else
      include_conductor = false
    end
    include_conductor = include_conductor ? nil : "and lower(instrument) <> 'conductor'"
    if params[:community_night_id]
      @community_night_instruments = CommunityNightInstrument.where("community_night_id = ? #{include_conductor}", params[:community_night_id].to_i)
      respond_to do |format|
        format.json { render json: @community_night_instruments, status: :ok }
      end
    else
      @community_night_instruments = CommunityNightInstrument.all
    end
  end

  # GET /community_night_instruments/1
  # GET /community_night_instruments/1.json
  def show
  end

  # GET /community_night_instruments/new
  def new
    @community_nights = CommunityNight.all
    @community_night_instrument = CommunityNightInstrument.new
  end

  # GET /community_night_instruments/1/edit
  def edit
    @community_nights = CommunityNight.all
  end

  # POST /community_night_instruments
  # POST /community_night_instruments.json
  def create
    @community_night_instrument = CommunityNightInstrument.new(community_night_instrument_params)

    respond_to do |format|
      if @community_night_instrument.save
        format.html { redirect_to @community_night_instrument, notice: 'Community night instrument was successfully created.' }
        format.json { render :show, status: :created, location: @community_night_instrument }
      else
        format.html { render :new }
        format.json { render json: @community_night_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /community_night_instruments/1
  # PATCH/PUT /community_night_instruments/1.json
  def update
    respond_to do |format|
      if @community_night_instrument.update(community_night_instrument_params)
        format.html { redirect_to @community_night_instrument, notice: 'Community night instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @community_night_instrument }
      else
        format.html { render :edit }
        format.json { render json: @community_night_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /community_night_instruments/1
  # DELETE /community_night_instruments/1.json
  def destroy
    @community_night_instrument.destroy
    respond_to do |format|
      format.html { redirect_to community_night_instruments_url, notice: 'Community night instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community_night_instrument
      @community_night_instrument = CommunityNightInstrument.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_night_instrument_params
      params.require(:community_night_instrument).permit(
        :community_night_id,
        :instrument,
        :limit,
        :available_to_opt_in
      )
    end
end
