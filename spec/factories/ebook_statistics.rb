FactoryBot.define do
  factory :ebook_statistic do
    visits { Faker::Number.between(from: 1, to: 100) }
    preview_views { Faker::Number.between(from: 1, to: visits) }
    purchases { Faker::Number.between(from: 1, to: visits) }
    ebook
  end
end
