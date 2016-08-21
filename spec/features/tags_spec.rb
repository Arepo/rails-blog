require 'rails_helper'

describe "Tags", type: :feature do

  context "Home page" do
    before do
      given_multiple_posts_exist
      when_i_visit_the_homepage
    end

    scenario "Displaying all tags" do
      then_i_should_see_all_their_tags
    end

    scenario "Linking to post by tag", js: true do
      and_click_on_a_tag
      then_i_should_see_only_posts_with_that_tag
    end
  end

  context "Logged in" do
    before { given_i_am_logged_in }

    scenario "Creating a tag when creating a post" do
      when_i_create_a_post
      and_i_fill_in_all_the_fields
      and_i_submit_new_tags
      then_those_tags_should_be_associated_with_the_post
    end

    scenario "Reusing a tag when creating a post" do
      given_tags_exist
      when_i_create_a_post
      and_i_fill_in_all_the_fields
      and_i_submit_multiple_tags
      then_those_tags_should_be_associated_with_the_post
    end

    scenario "Trying to create an existing tag" do
      given_tags_exist
      when_i_create_a_post
      and_i_fill_in_all_the_fields
      and_i_try_to_submit_existing_tags
      then_those_tags_should_be_associated_with_the_post
      but_no_new_tags_should_be_created
    end
  end

  def then_i_should_see_all_their_tags
    tags = Tag.names

    expect(page.text).to include *tags
  end

####

  def and_click_on_a_tag
binding.pry
    click_on Tag.first.name
  end

  def then_i_should_be_on_the_homepage
    expect(current_path).to eq '/'
  end

  def then_i_should_see_only_posts_with_that_tag
    expect(page.text).to include Post.first.title
    expect(page.text).not_to include Post.last.title
  end

####

  def and_i_submit_new_tags
    fill_in 'New tags', with: "Tag!, You're it!"
    and_submit_the_post
  end

  def then_those_tags_should_be_associated_with_the_post
    tags = Post.last.tags.pluck :name
    expect(tags).to include "tag!",
                            "you're it!"
  end

####

  def given_tags_exist
    Tag.create(name: "tag!")
    Tag.create(name: "you're it!")
  end

  def and_i_submit_multiple_tags
    name_1 = Tag.first.name
    name_2 = Tag.last.name

    check "tags_#{name_1}"
    check "tags_#{name_2}"
    and_submit_the_post
  end

  def and_i_try_to_submit_existing_tags
    fill_in 'New tags', with: "Tag!, You're it!"
    and_submit_the_post
  end

  def but_no_new_tags_should_be_created
    expect(Tag.count).to be 2
  end
end
