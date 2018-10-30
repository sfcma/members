require 'permissions'
class ApplicationController < ActionController::Base
  include Permissions

  # reset captcha code after each request for security
  after_action :reset_last_captcha_code!

  protect_from_forgery with: :exception, prepend: true

  def require_global_admin
    unless current_user && current_user.global_admin?
      redirect_to root_path and return
    end
  end

  def require_special_admin
    unless Permissions.special_global_admin(current_user)
      redirect_to root_path and return
    end
  end
end
