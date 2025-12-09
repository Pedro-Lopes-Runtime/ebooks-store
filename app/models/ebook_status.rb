class EbookStatus < ApplicationRecord
  belongs_to :ebook, optional: true
end
