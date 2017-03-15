class CommunityNightsController < ApplicationController
  before_action :set_community_night, only: [:show, :edit, :update, :destroy]

  # GET /community_nights
  # GET /community_nights.json
  def index
    @community_nights = CommunityNight.all
  end

  # GET /community_nights/1
  # GET /community_nights/1.json
  def show
  end

  # GET /community_nights/new
  def new
    @community_night = CommunityNight.new
  end

  # GET /community_nights/1/edit
  def edit
  end

  # POST /community_nights
  # POST /community_nights.json
  def create
    @community_night = CommunityNight.new(community_night_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community_night
      @community_night = CommunityNight.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_night_params
      params.require(:community_night).permit(:start, :end, :type, :name, :description)
    end
end
