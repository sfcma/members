class MemberCommunityNightsController < ApplicationController
  before_action :set_member_community_night, only: [:show, :edit, :update, :destroy]

  # GET /member_community_nights
  # GET /member_community_nights.json
  def index
    @member_community_nights = MemberCommunityNight.all
  end

  # GET /member_community_nights/1
  # GET /member_community_nights/1.json
  def show
  end

  # GET /member_community_nights/new
  def new
    @member_community_night = MemberCommunityNight.new
  end

  # GET /member_community_nights/1/edit
  def edit
  end

  # POST /member_community_nights
  # POST /member_community_nights.json
  def create
    @member_community_night = MemberCommunityNight.new(member_community_night_params)

    respond_to do |format|
      if @member_community_night.save
        format.html { redirect_to @member_community_night, notice: 'Member community night was successfully created.' }
        format.json { render :show, status: :created, location: @member_community_night }
      else
        format.html { render :new }
        format.json { render json: @member_community_night.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /member_community_nights/1
  # PATCH/PUT /member_community_nights/1.json
  def update
    respond_to do |format|
      if @member_community_night.update(member_community_night_params)
        format.html { redirect_to @member_community_night, notice: 'Member community night was successfully updated.' }
        format.json { render :show, status: :ok, location: @member_community_night }
      else
        format.html { render :edit }
        format.json { render json: @member_community_night.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_community_nights/1
  # DELETE /member_community_nights/1.json
  def destroy
    @member_community_night.destroy
    respond_to do |format|
      format.html { redirect_to member_community_nights_url, notice: 'Member community night was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member_community_night
      @member_community_night = MemberCommunityNight.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_community_night_params
      params.require(:member_community_night).permit(:status, :instrument, :member_id, :community_night_id)
    end
end
