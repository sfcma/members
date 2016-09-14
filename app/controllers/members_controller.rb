class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /members
  # GET /members.json
  def index
    @instruments = MemberInstrument.all.map{|mi| [mi.instrument.capitalize, mi.instrument]}.uniq

    if params[:instrument]
      @members = Member.joins(:member_instruments).where('instrument = ?', params[:instrument].snake_case)
    else
      @members = Member.includes(:member_instruments)
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member_instruments = @member.member_instruments
    #@set_member_instruments = @member_instruments.map(&:set_member_instrument)
    #@sets = nil# @set_member_instruments.map(&:set)
  end

  # GET /members/new
  def new
    @sets = PerformanceSet.all
    @member = Member.new
    @member.member_instruments.build
    @member.member_sets.build
    @member.member_notes.build
    @member.member_sets.set_member_instruments.build
  end

  # GET /members/1/edit
  def edit
    @sets = PerformanceSet.all
    @member.member_instruments.build
    @member.member_sets.build
    @member.member_sets.each do |ms|
      ms.set_member_instruments.build
    end
    @member.member_notes.build
    @member_instruments = @member.member_instruments
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    logger.info @member.inspect
    respond_to do |format|
      if @member.save
        go_back = "Member was successfully created."
        format.html { redirect_to new_member_path, notice: go_back }
        format.json { render :new, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    new_member_params = member_params.dup
    new_member_params[:member_instruments_attributes].reject! do |mik, miv|
      miv['instrument'] && miv['instrument'].empty?
    end
    new_member_params[:member_sets_attributes].reject! do |mik, miv|
      miv['instrument'] && miv['set_id'].empty?
    end

    respond_to do |format|
      if @member.update(new_member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone_1, :phone_1_type, :phone_2, :phone_2_type, :email_1, :email_2, :emergency_name, :emergency_relation, :emergency_phone, :playing_status, :initial_date, member_instruments_attributes: [:id, :instrument, :_destroy], member_sets_attributes: [:id, :set_id, :status, :rotating, :_destroy])
    end
end
