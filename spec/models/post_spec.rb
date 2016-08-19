require 'rails_helper'

describe Post do

  it { should have_many :tags }
  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :authors }
  it { should have_many(:posts_tags).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :topic }

  it "Can wrap itself in a decorator" do
    post = Post.new
    decorator = post.wrap

    expect(decorator).to be_an_instance_of PostDisplayDecorator
    expect(decorator.post).to be post
  end

  it "Has at least one author" do
    post = Post.new
    post.valid?

    expect(post.errors[:authors]).to include("is too short (minimum is 1 character)")
  end

  context "pseudo-scoping" do
    context "by topic" do
      let!(:post_1) { FactoryGirl.create :post, topic: "Rites of ascension in Westeros" }
      let!(:post_2) { FactoryGirl.create :post, topic: "Rights of orcs in Middle Earth" }

      it "finds and all posts with a given topic, case insensitively, wrapping them in a decorator" do
        first_topic = Post.in_topic "Rites of ascension in westeros"
        second_topic = Post.in_topic "Rights of orcs in middle earth"

        expect(first_topic.map(&:post)).to include post_1
        expect(first_topic.map(&:post)).not_to include post_2
        expect(second_topic.map(&:post)).to include post_2
        expect(second_topic.map(&:post)).not_to include post_1
      end
    end
  end
end
