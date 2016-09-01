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

  def self.topics
    pluck(:topic).uniq.compact
  end

  def international_date
    created_at.to_date
  end

  def tagged_with? tag
    tags.include? tag
  end

  def update_post_and_tags(post_params: {}, tag_params: {})
    transaction do
      update!(post_params)
      assign_tags(tag_params)
    end
  end

  def wrap
    PostDisplayDecorator.new self
  end

  private

  def assign_tags(tag_params)
    new_tags = tag_params.delete 'new_tags'

    tag_params.each_pair do |tag_name,v|
      tag = Tag.find_by name: tag_name
      tags.delete tag if v == '0'

      tags << tag if v == '1' && tags.exclude?(tag)
    end

    new_tags.split(',').map(&:strip).each { |tag| tags.with_name(tag).first_or_create }
  end
end
