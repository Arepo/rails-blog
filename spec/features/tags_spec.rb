require 'rails_helper'

describe "Tags" do

  context "Home page" do
    scenario "Displaying all tags" do
      given_multiple_posts_exist
      when_i_visit_the_homepage
      then_i_should_see_all_their_tags
    end
  end

  scenario "Creating a tag when creating a post" do
    when_i_create_a_post
  end

  def then_i_should_see_all_their_tags
    tags = Tag.names

    expect(page.text).to include *tags
  end
end
