class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :update_status ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    if params[:user][:profileable_type] == "Buyer"
      user_type = Buyer.create
    else
      user_type = Seller.create
    end
    @user = User.new(params.require(:user).permit(:username, :displayname, :email, :status).merge(profileable: user_type))
    if @user.save
      redirect_to @user
    else
      user_type.destroy
      render "new", status: 422
    end
  end

  def edit
  end

  def update
    if @user.update(params.require(:user).permit(:username, :displayname, :email, :status))
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
    params.require(:user).permit(:username, :displayname, :email, :status).each_value { |v| v.strip! if v.is_a? String }
  end
end
