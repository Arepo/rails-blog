FactoryGirl.define do
  factory :author do
    name { Faker::Superhero.name }
    email { Faker::Internet.email }
    blurb { Faker::StarWars.quote }
  end
end
