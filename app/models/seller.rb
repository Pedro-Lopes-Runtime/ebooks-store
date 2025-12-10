class Seller < ApplicationRecord
  has_one :user, as: :profileable
  has_many :ebooks
end
