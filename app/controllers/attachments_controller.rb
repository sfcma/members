class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :authenticate_user!

  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { "OK" }
      format.json { head :success }
    end
  end

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
