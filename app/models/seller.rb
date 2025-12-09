class Seller < ApplicationRecord
  has_one :user, as: :profileable
end
