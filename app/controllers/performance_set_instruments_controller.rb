class PerformanceSetInstrumentsController < ApplicationController
  before_action :set_performance_set_instrument, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]

  # GET /performance_set_instruments
  # GET /performance_set_instruments.json
  def index
    if params[:include_conductor] == "true"
      include_conductor = true
    else
      include_conductor = false
    end
    include_conductor = include_conductor ? nil : "and lower(instrument) <> 'conductor'"
    if params[:performance_set_id]
      @performance_set_instruments = PerformanceSetInstrument.where("performance_set_id = ? #{include_conductor}", params[:performance_set_id].to_i)
      respond_to do |format|
        format.json { render json: @performance_set_instruments, status: :ok }
      end
    else
      @performance_set_instruments = PerformanceSetInstrument.all
    end
  end

  # GET /performance_set_instrument/1
  # GET /performance_set_instrument/1.json
  def show
  end

  # GET /performance_set_instrument/new
  def new
    @performance_sets = PerformanceSet.all
    @performance_set_instrument = PerformanceSetInstrument.new
    @opt_in_messages = OptInMessage.all
  end

  # GET /performance_set_instruments/1/edit
  def edit
    @performance_sets = PerformanceSet.all
    @opt_in_messages = OptInMessage.all
  end

  # POST /performance_set_instruments
  # POST /performance_set_instruments.json
  def create
    @performance_set_instrument = PerformanceSetInstrument.new(performance_set_instrument_params)
    @opt_in_messages = OptInMessage.all
    respond_to do |format|
      if @performance_set_instrument.save
        format.html { redirect_to @performance_set_instrument, notice: 'Performance Set Instrument was successfully created.' }
        format.json { render :show, status: :created, location: @performance_set_instrument }
      else
        format.html { render :new }
        format.json { render json: @performance_set_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /performance_set_instruments/1
  # PATCH/PUT /performance_set_instruments/1.json
  def update
    @opt_in_messages = OptInMessage.all
    respond_to do |format|
      if @performance_set_instrument.update(performance_set_instrument_params)
        format.html { redirect_to @performance_set_instrument, notice: 'Performance Set Instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @performance_set_instrument }
      else
        format.html { render :edit }
        format.json { render json: @performance_set_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /performance_set_instruments/1
  # DELETE /performance_set_instruments/1.json
  def destroy
    @performance_set_instrument.destroy
    respond_to do |format|
      format.html { redirect_to performance_set_instruments_url, notice: 'Performance Set Instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_performance_set_instrument
    @performance_set_instrument = PerformanceSetInstrument.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def performance_set_instrument_params
    params.require(:performance_set_instrument).permit(
      :performance_set_id,
      :instrument,
      :limit,
      :standby_limit,
      :include_conductor,
      :available_to_opt_in,
      :opt_in_message_id
    )
  end
end
