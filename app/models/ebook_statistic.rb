class EbookStatistic < ApplicationRecord
  belongs_to :ebook
  has_many :visitor_statistics

  def update_visits
    self.visits += 1
    save
  end

  def update_preview_views
    self.preview_views += 1
  end

  def update_purchases
    self.purchases += 1
  end
end
