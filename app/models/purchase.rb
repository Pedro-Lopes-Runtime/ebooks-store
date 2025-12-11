class Purchase < ApplicationRecord
  belongs_to :buyer
  belongs_to :ebook
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
