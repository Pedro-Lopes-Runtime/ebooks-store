class Buyer < ApplicationRecord
  has_one :user, as => :profileable
end
