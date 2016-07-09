class Author < ApplicationRecord

  has_many :contributions
  has_many :posts, through: :contributions
end
