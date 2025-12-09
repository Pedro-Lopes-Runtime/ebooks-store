class Ebook < ApplicationRecord
  belongs_to :author
  has_one :ebook_status
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
end
