# spec/factories/ebooks.rb
FactoryBot.define do
  factory :purchase do
    association :user
    association :ebook
    price { Faker::Commerce.price(range: 9.99..99.99) }
  end
end
