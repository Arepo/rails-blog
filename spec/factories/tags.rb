FactoryGirl.define do
  factory :tag do
    name { Faker::Company.catch_phrase }
  end
end
