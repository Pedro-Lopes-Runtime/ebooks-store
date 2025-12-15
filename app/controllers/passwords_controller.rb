class PasswordsController < ApplicationController
  allow_unauthenticated_access except: %i[ expired_password update_expired_password]
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to sign_in_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to sign_in_path, notice: "Password has been reset."
    else
      redirect_to new_password_url(params[:token]), alert: "Passwords did not match."
    end
  end

  def expired_password
    render "edit"
  end

  def update_expired_password
    debugger
    if @current_user.update(params.permit(:password, :password_confirmation))
      redirect_to after_sign_in_url, notice: "Password has been updated."
    else
      redirect_to new_password_url(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to sign_in_path, alert: "Password reset link is invalid or has expired."
    end
end
