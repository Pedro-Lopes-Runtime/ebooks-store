desc "Inform user he has to update his password if it has not been updated in the last than 6 months"
task :password_update do
  users = User.where(password_updated_at: 6.months.ago.beginning_of_day..6.months.ago.end_of_day)
  users.each do |user|
    PasswordsMailer.expired_password(user).deliver_later
  end
end
