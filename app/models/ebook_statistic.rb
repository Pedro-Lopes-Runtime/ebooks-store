class EbookStatistic < ApplicationRecord
  belongs_to :ebook
  has_many :visitor_statistics
end
