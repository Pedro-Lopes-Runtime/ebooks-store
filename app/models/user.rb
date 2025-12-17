class User < ApplicationRecord
  enum :user_type, { seller: 0, buyer: 1 }, validate: true
  has_many :ebooks
  has_one_attached :profile_image
  has_secure_password
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 5, maximum: 30 }
  validates :displayname, length: { maximum: 30 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 100 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  before_create :set_password_updated_at
  before_save :update_password_updated_at, if: :will_save_change_to_password_digest?
  before_update :update_password_updated_at, if: :will_save_change_to_password_digest?

  def set_password_updated_at
    self.password_updated_at = self.updated_at
  end

  def update_password_updated_at
    self.password_updated_at = DateTime.now
  end

  def pay(value)
    self.balance -= value
    save
  end

  def deposit(value)
    self.balance += value
    save
  end

  def expired_password?
    self.password_updated_at <= 6.months.ago
  end

  def name
    self.displayname || self.username
  end

  def self.find_by_username_or_email(query)
    self.where("email = :query OR username = :query", query: query).first
  end
end
