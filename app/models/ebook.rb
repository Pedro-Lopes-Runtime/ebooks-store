class Ebook < ApplicationRecord
  enum :status, { draft: 0, pending: 1, live: 2 }, validate: true
  belongs_to :author
  belongs_to :user
  has_one :ebook_statistic
  has_one_attached :preview
  has_one_attached :cover
  has_and_belongs_to_many :tags
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
end
