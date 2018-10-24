class UsersController < ApplicationController
  before_action :require_global_admin


  def index
    @users = User.all
  end

  def show

  end

  def new
    @user = User.new
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

  def edit
  end

  def update
    respond_to do |format|
      if @user_permission.update(user_params)
        format.html { redirect_to @user_permission, notice: 'User permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_permission }
      else
        format.html { render :edit }
        format.json { render json: @user_permission.errors, status: :unprocessable_entity }
      end
    end
  end

end