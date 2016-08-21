FactoryGirl.define do
  factory :tag do
    sequence :name do |n|
      "taggytag#{n}"
    end
  end
end
