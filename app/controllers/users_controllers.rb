class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :displayname, :password))
    if @user.save
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(params.require(:user).permit(:username, :displayname))
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
