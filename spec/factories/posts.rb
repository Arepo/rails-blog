FactoryGirl.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Hipster.paragraph }
    topic
  end
end
