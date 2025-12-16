class UserMailer < ApplicationMailer
  def sale_commission
    @ebook = params[:ebook]
    seller = @ebook.user
    mail(to: seller.email, subjet: "One of your ebooks has been purchased")
  end

  def ebook_statistics
    @ebook = params[:ebook]
    seller = @ebook.user
    @statistics = @ebook.ebook_statistic
    mail(to: seller.email, subjet: "Ebook Statistics")
  end

  def welcome
    @user = params[:user]
    mail(to: @user.email, subjet: "Ebook Statistics")
  end
end
