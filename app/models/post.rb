class Post < ApplicationRecord
  # Added fields: body, title, topic

  has_many :contributions, dependent: :destroy
  has_many :authors, through: :contributions
  has_many :posts_tags
  has_many :tags, through: :posts_tags
  validates :title, :body, :topic, presence: true

  scope :in_topic, -> (topic) { where("lower(topic) = ?", topic.downcase) }

  def international_date
    created_at.to_date
  end

  def self.topics
    pluck(:topic).uniq.compact
  end
end
