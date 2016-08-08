class Author < ApplicationRecord

  has_many :contributions, dependent: :destroy
  has_many :posts, through: :contributions
end
