class Ebook < ApplicationRecord
  enum :status, { draft: 0, pending: 1, live: 2 }, validate: true
  belongs_to :author
  belongs_to :user
  has_one :ebook_statistic, dependent: :destroy
  has_one_attached :preview, dependent: :destroy
  has_one_attached :cover, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :buyers, through: :purchases, source: :user
  has_and_belongs_to_many :tags
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :initialize_statistics

  scope :published, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
  scope :pending, -> { where(status: "pending") }
  scope :by_seller, ->(seller) { where(user: seller) }

  def initialize_statistics
    create_ebook_statistic!
  end

  def submit_for_review!
    self.status = "pending" if self.status == "draft"
  end

  def publish!
    self.status = "live" if self.status == "pending"
  end

  def view_count
    self.ebook_statistic.visits
  end

  def purchase_count
    self.ebook_statistic.purchases
  end

  def log_visitor(request)
    self.ebook_statistic.visitor_statistics.create(request)
  end
end
