class AbsencesController < ApplicationController
  before_action :set_absence, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :new, :create]

  # GET /absences
  # GET /absences.json
  def index
    unless current_user
      redirect_to new_absence_url
    end
    @absences = Absence.all
  end

  # GET /absences/1
  # GET /absences/1.json
  def show
    @performance_sets = PerformanceSet.all
  end

  # GET /absences/new
  def new
    @performance_sets = PerformanceSet.now_or_future
    @absence = Absence.new
    render layout: 'anonymous' unless current_user.present?
  end

  # GET /absences/1/edit
  def edit
    @performance_sets = PerformanceSet.now_or_future
    @performance_set_dates = PerformanceSetDate.all
  end

  # POST /absences
  # POST /absences.json
  def create
    aparams = absence_params

    # figure out which member it is
    if aparams[:members][:email_1]
      member = nil
    else
      member = Member.where('email_1 = ? OR email_2 = ?', aparams[:members][:email_1], aparams[:members][:email_1]).first
    end

    if member
      aparams[:member_id] = member.id
    end
    aparams.delete(:members)

    # don't care which performance set it is
    aparams.delete(:performance_set_dates)

    @absence = Absence.new(aparams)
    @performance_sets = PerformanceSet.now_or_future

    respond_to do |format|
      if @absence.save
        if !current_user
          format.html { redirect_to new_absence_url, notice: 'Absence was successfully recorded. You can record another absence below.' }
        else
          format.html { redirect_to @absence, notice: 'Absence was successfully created.' }
          format.json { render :show, status: :created, location: @absence }
        end
      else
        if current_user
          format.html { render :new }
        else
          format.html { render :new, layout: 'anonymous' }
        end
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /absences/1
  # PATCH/PUT /absences/1.json
  def update
    @performance_sets = PerformanceSet.now_or_future

    respond_to do |format|
      if @absence.update(absence_params)
        format.html { redirect_to @absence, notice: 'Absence was successfully updated.' }
        format.json { render :show, status: :ok, location: @absence }
      else
        format.html { render :edit }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /absences/1
  # DELETE /absences/1.json
  def destroy
    @absence.destroy
    respond_to do |format|
      format.html { redirect_to absences_url, notice: 'Absence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_absence
    @absence = Absence.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def absence_params
    params.require(:absence).permit(
      :member_id,
      :performance_set_id,
      :performance_set_date_id,
      :date,
      :planned,
      :sub_found,
      performance_set_dates: [
        :performance_set_id
      ],
      members: [
        :email_1
      ]
    )
  end
end
