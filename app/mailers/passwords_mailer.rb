class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Reset your password", to: user.email
  end

  def expired_password(user)
    mail subject: "Password expired", to: user.email
  end
end
