FactoryBot.define do
  factory :visitor_statistic do
    ip { Faker::Internet.ip_v4_address }
    browser { Browser.new(Faker::Internet.user_agent).name }
    location { Faker::Address.country }
    ebook_statistic
  end
end
