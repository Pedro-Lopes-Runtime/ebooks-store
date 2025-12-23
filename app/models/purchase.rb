class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :ebook
  has_one :seller, through: :ebook, source: :user
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  after_create :update_ebook_statistics
  after_create_commit :trigger_notifications

  def update_ebook_statistics
    self.ebook.ebook_statistic.update_purchases
    request = Thread.current[:request]
    self.ebook.log_visitor(request) if request.present?
  end

  def trigger_notifications
    UserMailer.with(ebook: self.ebook).sale_commission.deliver_later
    UserMailer.with(ebook: self.ebook).ebook_statistics.deliver_later
  end
end
