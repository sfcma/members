class UsersController < ApplicationController
  before_action :require_special_admin


  def index
    @users = User.all
  end

  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    respond_to do |format|
      format.html do
        @user = User.find(params[:id])
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(params[:id])
    else
      render 'edit'
    end
  end

  def send_password_recovery_instructions
    User.find(params[:id]).send_reset_password_instructions
  end


  private

  def user_params
    params.require(:user).permit(
      :name, :email, :phone, :global_admin, :is_active
    )
  end

end