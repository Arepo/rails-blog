FactoryGirl.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Hipster.paragraph }
    topic { Faker::Book.genre }
    publish true

    after :build do |post, _|
      post.tags << build(:tag)
      post.authors << create(:author)
    end
  end
end
