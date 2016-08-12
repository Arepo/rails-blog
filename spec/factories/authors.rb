FactoryGirl.define do
  factory :author do
    name { Faker::Superhero.name }
    email { Faker::Internet.email }
    password 'unbreakable!'
    password_confirmation 'unbreakable!'
    # blurb { Faker::StarWars.quote }
  end
end
