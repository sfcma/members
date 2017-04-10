class EmailLogsController < ApplicationController
  def ping
    el = EmailLog.where(email_id: email_logs_params[:email_id].to_i, member_id: email_logs_params[:member_id].to_i)
    el.update(opened_at: Time.now)
    Rails.logger.info "Updated #{el.inspect}"
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_logs_params
      params.permit(
        :member_id,
        :email_id
      )
    end
end