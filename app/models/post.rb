class Post < ApplicationRecord

  has_many :contributions
  has_many :authors, through: :contributions
end
