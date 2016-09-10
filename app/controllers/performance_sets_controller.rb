class PerformanceSetsController < ApplicationController
  before_action :set_performance_set, only: [:show, :edit, :update, :destroy]

  # GET /performance_sets
  # GET /performance_sets.json
  def index
    @performance_sets = PerformanceSet.all
  end

  # GET /performance_sets/1
  # GET /performance_sets/1.json
  def show
  end

  # GET /performance_sets/new
  def new
    @performance_set = PerformanceSet.new
  end

  # GET /performance_sets/1/edit
  def edit
  end

  # POST /performance_sets
  # POST /performance_sets.json
  def create
    @performance_set = PerformanceSet.new(performance_set_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_performance_set
      @performance_set = PerformanceSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def performance_set_params
      params.require(:performance_set).permit(:performance_id, :start_date, :end_date)
    end
end
