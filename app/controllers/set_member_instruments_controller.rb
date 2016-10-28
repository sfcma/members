class SetMemberInstrumentsController < ApplicationController
  before_action :set_set_member_instrument, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /set_member_instruments
  # GET /set_member_instruments.json
  def index
    @set_member_instruments = SetMemberInstrument.all
  end

  # GET /set_member_instruments/1
  # GET /set_member_instruments/1.json
  def show
  end

  # GET /set_member_instruments/new
  def new
    @set_member_instrument = SetMemberInstrument.new
  end

  # GET /set_member_instruments/1/edit
  def edit
  end

  # POST /set_member_instruments
  # POST /set_member_instruments.json
  def create
    @set_member_instrument = SetMemberInstrument.new(set_member_instrument_params)

    respond_to do |format|
      if @set_member_instrument.save
        format.html { redirect_to @set_member_instrument, notice: 'Set member instrument was successfully created.' }
        format.json { render :show, status: :created, location: @set_member_instrument }
      else
        format.html { render :new }
        format.json { render json: @set_member_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /set_member_instruments/1
  # PATCH/PUT /set_member_instruments/1.json
  def update
    respond_to do |format|
      if @set_member_instrument.update(set_member_instrument_params)
        format.html { redirect_to @set_member_instrument, notice: 'Set member instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @set_member_instrument }
      else
        format.html { render :edit }
        format.json { render json: @set_member_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /set_member_instruments/1
  # DELETE /set_member_instruments/1.json
  def destroy
    @set_member_instrument.destroy
    respond_to do |format|
      format.html { redirect_to set_member_instruments_url, notice: 'Set member instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_set_member_instrument
    @set_member_instrument = SetMemberInstrument.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def set_member_instrument_params
    params.require(:set_member_instrument).permit(
      :member_set_id,
      :member_instrument_id
    )
  end
end
