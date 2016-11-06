class PerformancePiecesController < ApplicationController
  before_action :set_performance_piece, only: [:show, :edit, :update, :destroy]

  # GET /performance_pieces
  # GET /performance_pieces.json
  def index
    @performance_pieces = PerformancePiece.all
  end

  # GET /performance_pieces/1
  # GET /performance_pieces/1.json
  def show
    @audit_string = helpers.generate_audit_array(@performance_piece)
  end

  # GET /performance_pieces/new
  def new
    @performance_piece = PerformancePiece.new
    @performance_sets = PerformanceSet.all
  end

  # GET /performance_pieces/1/edit
  def edit
    @performance_sets = PerformanceSet.all
  end

  # POST /performance_pieces
  # POST /performance_pieces.json
  def create
    @performance_piece = PerformancePiece.new(performance_piece_params)

    respond_to do |format|
      if @performance_piece.save
        format.html { redirect_to @performance_piece, notice: 'Performance Piece was successfully created.' }
        format.json { render :show, status: :created, location: @performance_piece }
      else
        format.html { render :new }
        format.json { render json: @performance_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /performance_pieces/1
  # PATCH/PUT /performance_pieces/1.json
  def update
    respond_to do |format|
      if @performance_piece.update(performance_piece_params)
        format.html { redirect_to @performance_piece, notice: 'Performance Piece was successfully updated.' }
        format.json { render :show, status: :ok, location: @performance_piece }
      else
        format.html { render :edit }
        format.json { render json: @performance_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /performance_pieces/1
  # DELETE /performance_pieces/1.json
  def destroy
    @performance_piece.destroy
    respond_to do |format|
      format.html { redirect_to performance_pieces_url, notice: 'Performance Piece was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_performance_piece
    @performance_piece = PerformancePiece.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def performance_piece_params
    params.require(:performance_piece).permit(
      :title,
      :compose,
      :performance_set_id
    )
  end
end
