class Topic < ApplicationRecord
  # Added fields: title

  before_validation :capitalize_title

  validates :title, uniqueness: true
  has_many :posts

  def capitalize_title
    self.title = title.capitalize
  end

  def parameterized_title
    title.parameterize
  end
end
