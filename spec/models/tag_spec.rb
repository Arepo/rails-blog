require 'rails_helper'

describe Tag do

  it "downcases its name before validation" do
    tag = Tag.new(name: 'Tag O SHAAAAME')
    tag.valid?
    expect(tag.name).to eq 'tag o shaaaame'
  end

  context "covering for shoulda-matchers' dubious logic" do
    it "Validates the presence of name" do
      tag = Tag.new
      tag.valid?

      expect(tag.errors[:name]).to include "can't be blank"
    end

    it "Validates the uniqueness of name" do
      Tag.create(name: "I aaaaam the one and only!")
      tag = Tag.create(name: "I aaaaam the one and only!")

      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include 'has already been taken'
    end
  end

  it { should have_many :posts }
  it { should have_many :posts_tags }
end
