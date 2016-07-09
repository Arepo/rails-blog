class Post < ApplicationRecord

  has_many :contributions
  has_many :authors, through: :contributions
  has_many :posts_tags
  has_many :tags, through: :posts_tags
end
