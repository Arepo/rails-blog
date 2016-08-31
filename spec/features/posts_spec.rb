require "rails_helper"

describe "Posts", type: :feature do
  context "When logged in" do
    before { given_i_am_logged_in }

    describe "Creating a post" do
      context "successfully" do
        context "with new topic" do
          scenario "with all fields filled in, creating a new topic" do
            when_i_create_a_post
            and_i_submit_all_the_fields
            then_the_page_should_display_the_post
            and_the_post_count_should_now_be 1
          end
        end

        context "in existing topic" do
          scenario "with all fields filled in, using existing topic" do
            given_a_post_already_exists
            when_i_create_a_post
            and_i_submit_an_existing_topic
            then_the_page_should_display_the_post
            and_the_post_count_should_now_be 2
          end

          scenario "with_multiple_authors" do
            given_another_author_exists
            and_i_submit_a_post_with_the_other_author
            then_we_should_both_be_authors_of_the_post
          end
        end

        context "Markdown" do
          scenario "gets parsed into html when displaying" do
            given_a_post_with_markdown
            when_i_view_the_post
            then_it_should_display_with_html
          end
        end
      end

      context "unsuccessfully" do
        scenario "with fields missing" do
          when_i_create_a_post
          and_submit_the_post
          then_the_page_should_display_errors
          and_the_post_count_should_now_be 0
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

      scenario "while reassigning tags" do
        given_a_post_with_two_tags_exists
        when_i_edit_a_post
        and_i_delete_a_tag
        then_the_post_should_have_just_the_remaining_tag
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
        and_see_confirmation_of_the_deletion
      end
    end
  end

  context "Not logged in" do
    scenario "Can't create posts" do
      when_i_visit_the_homepage
      then_i_should_not_have_the_option_to_create_a_post
    end

    scenario "Can't edit or delete posts" do
      given_a_post_already_exists
      when_i_view_the_post
      then_i_should_not_be_able_to_edit_or_delete_it
    end
  end
end
