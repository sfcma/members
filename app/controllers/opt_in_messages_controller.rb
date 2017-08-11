class OptInMessagesController < ApplicationController
  before_action :set_opt_in_message, only: [:show, :edit, :update, :destroy]

  # GET /opt_in_messages
  # GET /opt_in_messages.json
  def index
    @opt_in_messages = OptInMessage.all
  end

  # GET /opt_in_messages/1
  # GET /opt_in_messages/1.json
  def show
  end

  # GET /opt_in_messages/new
  def new
    @opt_in_message = OptInMessage.new
  end

  # GET /opt_in_messages/1/edit
  def edit
  end

  # POST /opt_in_messages
  # POST /opt_in_messages.json
  def create
    @opt_in_message = OptInMessage.new(opt_in_message_params)

    respond_to do |format|
      if @opt_in_message.save
        format.html { redirect_to @opt_in_message, notice: 'Opt in message was successfully created.' }
        format.json { render :show, status: :created, location: @opt_in_message }
      else
        format.html { render :new }
        format.json { render json: @opt_in_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /opt_in_messages/1
  # PATCH/PUT /opt_in_messages/1.json
  def update
    respond_to do |format|
      if @opt_in_message.update(opt_in_message_params)
        format.html { redirect_to @opt_in_message, notice: 'Opt in message was successfully updated.' }
        format.json { render :show, status: :ok, location: @opt_in_message }
      else
        format.html { render :edit }
        format.json { render json: @opt_in_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opt_in_messages/1
  # DELETE /opt_in_messages/1.json
  def destroy
    @opt_in_message.destroy
    respond_to do |format|
      format.html { redirect_to opt_in_messages_url, notice: 'Opt in message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opt_in_message
      @opt_in_message = OptInMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opt_in_message_params
      params.require(:opt_in_message).permit(:message, :title)
    end
end
