class UsersController < ApplicationController
  def index
    unless current_user.global_admin?
      redirect_to root_path and return
    end
    @users = User.all
  end
end