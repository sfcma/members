class MemberInstrumentsController < ApplicationController
  before_action :set_member_instrument, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /member_instruments
  # GET /member_instruments.json
  def index
    @member_instruments = MemberInstrument.all
  end

  # GET /member_instruments/1
  # GET /member_instruments/1.json
  def show
    @audit_string = helpers.generate_audit_array(@member_instrument)
  end

  # GET /member_instruments/new
  def new
    @member_instrument = MemberInstrument.new
  end

  # GET /member_instruments/1/edit
  def edit
  end

  # POST /member_instruments
  # POST /member_instruments.json
  def create
    @member_instrument = MemberInstrument.new(member_instrument_params)

    respond_to do |format|
      if @member_instrument.save
        format.html { redirect_to @member_instrument, notice: 'Member instrument was successfully created.' }
        format.json { render :show, status: :created, location: @member_instrument }
      else
        format.html { render :new }
        format.json { render json: @member_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /member_instruments/1
  # PATCH/PUT /member_instruments/1.json
  def update
    respond_to do |format|
      if @member_instrument.update(member_instrument_params)
        format.html { redirect_to @member_instrument, notice: 'Member instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @member_instrument }
      else
        format.html { render :edit }
        format.json { render json: @member_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_instruments/1
  # DELETE /member_instruments/1.json
  def destroy
    @member_instrument.destroy
    respond_to do |format|
      format.html { redirect_to member_instruments_url, notice: 'Member instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member_instrument
    @member_instrument = MemberInstrument.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_instrument_params
    params.require(:member_instrument).permit(:member_id, :instrument)
  end
end
