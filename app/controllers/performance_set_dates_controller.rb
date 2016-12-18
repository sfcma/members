class PerformanceSetDatesController < ApplicationController
  before_action :set_performance_set_date, only: [:show, :edit, :update, :destroy]

  # GET /performance_set_dates
  # GET /performance_set_dates.json
  def index
    @performance_set_dates = PerformanceSetDate.includes(:performance_set).order(:performance_set_id).all

    @performance_sets_for_filter = PerformanceSet.all.map { |ps| [ps.name, ps.id] }
    @performance_sets_for_filter = @performance_sets_for_filter.unshift(['All Sets', 0])

    if params[:set]
      if PerformanceSet.where('id = ?', params[:set]).count > 0
        @performance_set = params[:set]
        @performance_set_label = @performance_set
      end
    end

    if @performance_set
      @members = @members.where('member_sets.performance_set_id = ?', params[:set])
    end
  end

  # GET /performance_set_dates/1
  # GET /performance_set_dates/1.json
  def show
  end

  # GET /performance_set_dates/new
  def new
    @performance_sets = PerformanceSet.all
    @performance_set_date = PerformanceSetDate.new
  end

  # GET /performance_set_dates/1/edit
  def edit
    @performance_sets = PerformanceSet.all
  end

  # POST /performance_set_dates
  # POST /performance_set_dates.json
  def create
    @performance_set_date = PerformanceSetDate.new(performance_set_date_params)

    respond_to do |format|
      if @performance_set_date.save
        format.html { redirect_to @performance_set_date, notice: 'Performance set date was successfully created.' }
        format.json { render :show, status: :created, location: @performance_set_date }
      else
        format.html { render :new }
        format.json { render json: @performance_set_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /performance_set_dates/1
  # PATCH/PUT /performance_set_dates/1.json
  def update
    respond_to do |format|
      if @performance_set_date.update(performance_set_date_params)
        format.html { redirect_to @performance_set_date, notice: 'Performance set date was successfully updated.' }
        format.json { render :show, status: :ok, location: @performance_set_date }
      else
        format.html { render :edit }
        format.json { render json: @performance_set_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /performance_set_dates/1
  # DELETE /performance_set_dates/1.json
  def destroy
    @performance_set_date.destroy
    respond_to do |format|
      format.html { redirect_to performance_set_dates_url, notice: 'Performance set date was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_performance_set_date
      @performance_set_date = PerformanceSetDate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def performance_set_date_params
      params.require(:performance_set_date).permit(
        :performance_set_id,
        :date
      )
    end
end
