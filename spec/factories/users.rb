FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.user_name(specifier: 5) }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
    status { true }

    trait :seller do
      user_type { :seller }
    end

    trait :buyer do
      user_type { :buyer }
    end

    trait :disabled do
      status { false }
    end

    trait :seller_with_ebooks do
      user_type { :seller }
      ebooks_count { Faker::Number.between(from: 2, to: 10) }
    end

    transient do
      ebooks_count { 0 }
    end

    after(:create) do |user, evaluator|
      create_list(:ebook, evaluator.ebooks_count, user: user)
    end
  end
end
