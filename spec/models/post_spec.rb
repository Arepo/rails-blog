require 'rails_helper'

describe Post do

  it { should have_many :tags }
  it { should have_many(:contributions).dependent(:destroy) }
  it { should have_many :authors }
  it { should have_many(:posts_tags).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :topic }

  let (:post) { FactoryGirl.build :post }

  it "Has at least one author" do
    post.authors.delete_all
    post.valid?

    expect(post.errors[:authors]).to include("is too short (minimum is 1 character)")
  end

  context "Post API" do
    context '#list_tags' do

      it 'gives all its tags as a string' do
        tag1 = Tag.create name: 'tag1'
        tag2 = Tag.create name: 'tag2'

        post.tags += [tag1, tag2]
        post.save!
        expect(post.list_tags).to include "tag1 tag2"
      end
    end

    context '#tagged_with?' do
      it 'checks whether it has a given tag' do
        actual_tag = post.tags.first
        hypothetical_tag = Tag.create!(name: 'Unloved')

        expect(post).to be_tagged_with actual_tag
        expect(post).not_to be_tagged_with hypothetical_tag
      end
    end

    context '#update_post_and_tags' do
      before { post.save }

      it 'Updates from two sets of params' do
        current_tag = post.tags.first.name
        Tag.create!(name: "funkalicious")

        post_params = {
          title: "Swankeh new title"
        }

        tag_params = {
          "#{current_tag}"=>"0", "funkalicious"=>"1", "new_tags"=>"monster, madness"
        }

        post.update_post_and_tags(post_params: post_params, tag_params: tag_params)

        expect(post.reload.title).to eq "Swankeh new title"

        tags = post.tags.pluck :name
        expect(tags).not_to include current_tag
        expect(tags).to include "funkalicious",
                                "monster",
                                "madness"
      end
    end

    context '#wrap' do
     it 'wraps itself in a PostDisplayDecorator instance' do
        decorator = post.wrap

        expect(decorator).to be_an_instance_of PostDisplayDecorator
        expect(decorator.post).to be post
      end
    end
  end

  context "scoping pseudo-scoping" do

    let!(:post_1) { FactoryGirl.create :post, topic: "Rites of ascension in Westeros" }
    let!(:post_2) { FactoryGirl.create :post, topic: "Rights of orcs in Middle Earth" }

    context "by topic" do
      it "finds and all posts with a given topic, case insensitively, wrapping them in a decorator" do
        first_topic = Post.in_topic "Rites of ascension in westeros"
        second_topic = Post.in_topic "Rights of orcs in middle earth"

        expect(first_topic.map(&:post)).to include post_1
        expect(first_topic.map(&:post)).not_to include post_2
        expect(second_topic.map(&:post)).to include post_2
        expect(second_topic.map(&:post)).not_to include post_1
      end
    end

    context "by tag" do
      let(:tag1) { post_1.tags.first.to_s }
      let(:tag2) { post_2.tags.first.to_s }

      it "finds all posts with specified tag or tags" do
        expect(Post.tagged_with(tag1)).to include post_1
        expect(Post.tagged_with(tag1)).not_to include post_2

        expect(Post.tagged_with(tag2)).not_to include post_1
        expect(Post.tagged_with(tag2)).to include post_2

        expect(Post.tagged_with(tag1, tag2)).to include post_1, post_2
      end
    end

    context "published only" do
      it "Finds all published posts" do
        expect(Post.published).to include post_1, post_2

        post_1.update(publish: false)
        expect(Post.published).not_to include post_1
      end
    end
  end
end
