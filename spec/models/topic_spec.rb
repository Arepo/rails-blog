require 'rails_helper'

describe Topic do

  it "Capitalizes the title before validation" do
    topic = Topic.new(title: "the Angry heavens")
    topic.valid?
    expect(topic.title).to eq "The angry heavens"
  end

  it "Validates the uniqueness of title" do
    Topic.create(title: "I aaaaam the one and only!")
    topic = Topic.new(title: "I aaaaam the one and only!")

    expect(topic).not_to be_valid
  end
end
