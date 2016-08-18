require 'rails_helper'

describe Post do

  it { should have_many :tags }
  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :authors }
  it { should have_many(:posts_tags).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :topic }

  context "scoping" do
    context "by topic" do
      let!(:post_1) { FactoryGirl.create :post, topic: "Rites of ascension in Westeros" }
      let!(:post_2) { FactoryGirl.create :post, topic: "Rights of orcs in Middle Earth" }

      it "finds all posts with a given topic, case insensitively" do
        first_topic = Post.in_topic "Rites of ascension in westeros"
        second_topic = Post.in_topic "Rights of orcs in middle earth"

        expect(first_topic).to include post_1
        expect(first_topic).not_to include post_2
        expect(second_topic).to include post_2
        expect(second_topic).not_to include post_1
      end
    end
  end

  context "Markdown" do
    it "Renders markdown versions of its title, body and topic" do
      post = Post.new(
        title: "Reasons why I'm **better** than Neil",
        body: "* I make seven layer bean dip of the gods
               * I’m also in Halo 3 What are the odds?",
        topic: 'Important _Sience_!'
      )

      expect(post.title).to include "<strong>better</strong>"
      expect(post.body).to include  "<ul>",
                                    "<li>I make seven layer bean dip of the gods</li>",
                                    "<li>I’m also in Halo 3 What are the odds?</li>"
      expect(post.topic).to include "<em>Science</em>"
    end
  end
end
