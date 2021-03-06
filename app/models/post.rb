class Post < ApplicationRecord
  # Added fields: body, title, topic, publish

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  has_many :contributions, dependent: :destroy
  has_many :authors, through: :contributions
  has_many :posts_tags, dependent: :destroy
  has_many :tags, through: :posts_tags

  validates :title, :body, :topic, presence: true
  validates :authors, length: { minimum: 1 }

  scope :published, -> { where publish: true }

  before_save :set_publication_date, if: :newly_published?

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

  def extract_tags tag_params
    tags = tag_params.select { |_,v| v == '1' }.keys
    new_tags = (tag_params['new_tags'] || "").split(',').map(&:strip)

    tags | new_tags
  end

  def international_date
    created_at.to_date
  end

  def list_tags
    tags.pluck(:name).join ' '
  end

  def tagged_with? tag
    tags.include? tag
  end

  def update_post_and_tags post_params: {}, tag_params: {}
    update_tags(tag_params)
    update(post_params)
  end

  def wrap
    PostDisplayDecorator.new self
  end

  def should_generate_new_friendly_id?
    # Friendly ID method
    changes.include? :title
  end

  private

  def newly_published?
    (changes.include? :publish) && !published_on
  end

  def set_publication_date
    self.published_on = Date.today
  end

  def update_tags tag_params
    updated_tags = extract_tags(tag_params)

    transaction do
      tags.delete_all
      updated_tags.each { |tag| tags << Tag.with_name(tag).first_or_create }
    end
  end
end
