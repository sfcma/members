class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_action :reset_last_captcha_code!

  protect_from_forgery with: :exception, prepend: true

  def require_global_admin
    unless current_user.global_admin?
      redirect_to root_path and return
    end
  end
end
