class Author < ApplicationRecord
  has_many :ebooks
  validates :name, presence: true
end
