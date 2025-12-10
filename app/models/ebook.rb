class Ebook < ApplicationRecord
  belongs_to :author
  belongs_to :ebook_status
  belongs_to :seller
  has_one :ebook_statistic
  has_one_attached :preview
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
end
