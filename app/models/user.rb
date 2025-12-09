class User < ApplicationRecord
  belongs_to :profileable, polymorphic: true
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 5, maximum: 30 }
  validates :displayname, presence: true,
                          length: { maximum: 30 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 100 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
