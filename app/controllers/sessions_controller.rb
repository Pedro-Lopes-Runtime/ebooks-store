class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    redirect_to root_url if signed_in?
  end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      new_session user
      redirect_to after_sign_in_url
    else
      flash[:alert] = "Try another email address or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    sign_out
    redirect_to sign_in_path
  end
end
