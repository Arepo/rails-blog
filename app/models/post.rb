class Post < ApplicationRecord
  # Added fields: body, title, topic

  has_many :contributions, dependent: :destroy
  has_many :authors, through: :contributions
  has_many :posts_tags, dependent: :destroy
  has_many :tags, through: :posts_tags

  validates :title, :body, :topic, presence: true
  validates :authors, length: { minimum: 1 }

  def self.in_topic topic
    where(
      "lower(topic) = ?",
      ActionController::Base.helpers.strip_tags(topic.downcase.chomp)
    ).map(&:wrap)
  end

  def self.tagged_with *tags
    joins(:tags).where(tags: { name: tags })
  end

  def international_date
    created_at.to_date
  end

  def self.topics
    pluck(:topic).uniq.compact
  end

  def wrap
    PostDisplayDecorator.new self
  end
end
