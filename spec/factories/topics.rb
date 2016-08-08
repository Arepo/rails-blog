FactoryGirl.define do
  factory :topic do
    title { Faker::Book.title }
  end
end
