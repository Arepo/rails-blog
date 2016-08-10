require "rails_helper"

describe "Posts", type: :feature do
  describe "Creating a post" do
    context "successfully" do
      context "with new topic" do
        scenario "with all fields filled in, creating a new topic" do
          when_i_create_a_post
          and_i_submit_all_the_fields
          then_the_page_should_display_the_post
          and_the_post_count_should_now_be(1)
        end
      end

      context "in existing topic" do
        scenario "with all fields filled in, using existing topic" do
          given_a_post_already_exists
          when_i_create_a_post
          and_i_submit_an_existing_topic
          then_the_page_should_display_the_post
          and_the_post_count_should_now_be(2)
        end
      end
    end

    context "unsuccessfully" do
      scenario "with fields missing" do
        when_i_create_a_post
        and_submit_the_post
        then_the_page_should_display_errors
        and_the_post_count_should_now_be(0)
      end
    end
  end

  describe "Editing a post" do
    scenario "successfully" do
      given_a_post_already_exists
      when_i_edit_a_post
      and_i_submit_all_the_fields
      then_the_page_should_display_the_post
    end

    scenario "unsuccessfully" do
      given_a_post_already_exists
      when_i_edit_a_post
      and_i_remove_fields
      and_submit_the_post
      then_the_page_should_display_errors
    end
  end

  describe "Displaying all posts" do

    scenario "All post titles and creation dates are listed under a primary topic heading" do
      given_multiple_posts_exist
      when_i_visit_the_homepage
      then_i_should_see_each_post_listed_under_its_topic
    end
  end

  describe "Viewing a single post" do
    scenario "Navigating from the index page" do
      given_a_post_already_exists
      when_i_visit_the_homepage
      then_i_should_be_able_to_navigate_to_the_post
    end
  end

  describe "Deleting a post" do
    scenario "removes it from the db" do
      given_a_post_already_exists
      when_i_view_the_post
      then_i_should_be_able_to_delete_it
    end
  end
end
