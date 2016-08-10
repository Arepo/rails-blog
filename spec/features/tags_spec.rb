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
    and_i_fill_in_all_the_fields
    and_i_submit_new_tags
    then_those_tags_should_be_associated_with_the_post
  end

  def then_i_should_see_all_their_tags
    tags = Tag.names

    expect(page.text).to include *tags
  end

####

  def and_i_submit_new_tags
    fill_in 'New tags', with: "Tag! You're it!"
    and_submit_the_post
  end

  def then_those_tags_should_be_associated_with_the_post
    expect(Post.last.tags.pluck(:name)).to include "Tag!",
                                                   "You're",
                                                   "it!"
  end
end
