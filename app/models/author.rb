class Author < ApplicationRecord

  has_many :contributions, dependent: :destroy
  has_many :posts, through: :contributions

  validates :email, :name, :password, presence: true
end
