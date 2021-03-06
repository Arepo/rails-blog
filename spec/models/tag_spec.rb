require 'rails_helper'

describe Tag do

  it "downcases its name before validation" do
    tag = Tag.new(name: 'Tag O SHAAAAME')
    tag.valid?
    expect(tag.name).to eq 'tag o shaaaame'
  end

  it "represents itself by its name" do
    tag = Tag.new(name: 'horace the tag')
    expect(tag.to_s).to eq 'horace the tag'
  end

  it "searches for a downcased equivalent of passed in string" do
    tag = Tag.create!(name: 'cappy')
    expect(Tag.with_name('CAPPY')).to include tag
  end

  context "covering for shoulda-matchers' dubious logic" do
    it "Validates the presence of name" do
      tag = Tag.new
      tag.valid?

      expect(tag.errors[:name]).to include "can't be blank"
    end

    it "Validates the uniqueness of name" do
      Tag.create!(name: "I aaaaam the one and only!")
      expect { Tag.create!(name: "I aaaaam the one and only!") }.to raise_error { ActiveRecord::RecordInvalid }
    end
  end

  it { should have_many :posts }
  it { should have_many(:posts_tags).dependent(:destroy) }
end
