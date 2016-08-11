class Tag < ApplicationRecord

  has_many :posts_tags
  has_many :posts, through: :posts_tags

  validates :name, uniqueness: true
  validates :name, presence: true

  before_validation :downcase_name

  scope :with_name, -> (name) { where name: name.downcase }

  def self.names
    pluck(:name)
  end

  def to_s
    name
  end

  private

  def downcase_name
    self.name = name.downcase
  end
end
