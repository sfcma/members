class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /members
  # GET /members.json
  def index
    @members = Member.all
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member_instruments = @member.member_instruments
    @set_member_instruments = @member_instruments.map(&:set_member_instrument)
    @sets = @set_member_instruments.map(&:set)
  end

  # GET /members/new
  def new
    @member = Member.new
    @member_instrument = @member.member_instruments.build
    logger.info @member.member_instruments
  end

  # GET /members/1/edit
  def edit
    @member_instruments = @member.member_instruments.build
    logger.info @member.member_instruments
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

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
    respond_to do |format|
      if @member.update(member_params)
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
      params.require(:member).permit(:first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone_1, :phone_1_type, :phone_2, :phone_2_type, :email_1, :email_2, :emergency_name, :emergency_relation, :emergency_phone, :playing_status, {:member_instruments => [:instrument]})
    end
end
