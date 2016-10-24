class MemberNotesController < ApplicationController
  before_action :set_member_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /member_notes
  # GET /member_notes.json
  def index
    @member_notes = MemberNote.all
  end

  # GET /member_notes/1
  # GET /member_notes/1.json
  def show
  end

  # GET /member_notes/new
  def new
    @member_note = MemberNote.new
  end

  # GET /member_notes/1/edit
  def edit
  end

  # POST /member_notes
  # POST /member_notes.json
  def create
    @member_note = MemberNote.new(member_note_params)

    respond_to do |format|
      if @member_note.save
        format.html { redirect_to @member_note, notice: 'Member note was successfully created.' }
        format.json { render :show, status: :created, location: @member_note }
      else
        format.html { render :new }
        format.json { render json: @member_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /member_notes/1
  # PATCH/PUT /member_notes/1.json
  def update
    respond_to do |format|
      if @member_note.update(member_note_params)
        format.html { redirect_to @member_note, notice: 'Member note was successfully updated.' }
        format.json { render :show, status: :ok, location: @member_note }
      else
        format.html { render :edit }
        format.json { render json: @member_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_notes/1
  # DELETE /member_notes/1.json
  def destroy
    @member_note.destroy
    respond_to do |format|
      format.html { redirect_to member_notes_url, notice: 'Member note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member_note
    @member_note = MemberNote.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_note_params
    params.require(:member_note).permit(
      :member_id,
      :user_id,
      :note,
    )
  end
end
