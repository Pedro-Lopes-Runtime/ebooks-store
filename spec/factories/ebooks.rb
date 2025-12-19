# spec/factories/ebooks.rb
FactoryBot.define do
  factory :ebook do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    price { Faker::Commerce.price(range: 9.99..99.99) }
    status { :draft }
    user
    author

    trait :draft do
      status { :draft }
    end

    trait :pending do
      status { :pending }
    end

    trait :published do
      status { :live }
    end

    trait :with_pdf do
      after(:create) do |ebook|
        ebook.preview.attach(
          io: StringIO.new("%PDF-1.4 fake pdf content"),
          filename: "preview.pdf",
          content_type: "application/pdf"
        )
      end
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 79.99..199.99) }
    end

    transient do
      purchases_count { 0 }
      tags_count { 0 }
    end

    after(:create) do |ebook, evaluator|
      create_list(:purchase, evaluator.purchases_count, ebook: ebook)
      create_list(:tag, evaluator.tags_count, ebooks: [ ebook ])
    end
  end
end
