FactoryGirl.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Hipster.paragraph }
    topic { Faker::Book.genre }

    after :build do |post, _|
      author = create(:author)
      post.authors << author
    end
  end
end
