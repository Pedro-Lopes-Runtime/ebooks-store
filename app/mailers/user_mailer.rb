class UserMailer < ApplicationMailer
  def sale_commission
    @ebook = params[:ebook]
    seller = @ebook.seller
    mail(to: seller.user.email, subjet: "One of your ebooks has been purchased")
  end

  def ebook_statistics
    @ebook = params[:ebook]
    seller = @ebook.seller
    @statistics = @ebook.ebook_statistic
    mail(to: seller.user.email, subjet: "Ebook Statistics")
  end

  def welcome
    @user = params[:user]
    mail(to: @user.email, subjet: "Ebook Statistics")
  end
end
