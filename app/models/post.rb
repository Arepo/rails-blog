class Post < ApplicationRecord
  # Added fields: body, title

  has_many :contributions, dependent: :destroy
  has_many :authors, through: :contributions
  has_many :posts_tags
  has_many :tags, through: :posts_tags
  validates :title, presence: true
  validates :body, presence: true

  def international_date
    created_at.to_date.to_formatted_s :db
  end
end
