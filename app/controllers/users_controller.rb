class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :update_status ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    redirect_to root_url if signed_in?
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :email, :status, :password, :password_confirmation, :user_type).each_value { |v| v.strip! if v.is_a? String })
    if @user.save
      UserMailer.with(user: @user).welcome.deliver_later
      redirect_to sign_in_path
    else
      render "new", status: 422
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render "edit", status: 422
    end
  end

  def destroy
    @user.destroy
  end

  def update_status
    @user.status = !@user.status
    @user.save
    redirect_back_or_to "/"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :displayname, :email, :status, :profile_image).each_value { |v| v.strip! if v.is_a? String }
  end
end
