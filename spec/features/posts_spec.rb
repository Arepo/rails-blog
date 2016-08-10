require "rails_helper"

describe "Posts", type: :feature do
  describe "Creating a post" do
    context "successfully" do
      context "with new topic" do
        scenario "with all fields filled in, creating a new topic" do
          when_i_create_a_post
          and_i_fill_in_all_the_fields
          then_the_page_should_display_the_post
          and_the_post_count_should_now_be(1)
        end
      end

      context "in existing topic" do
        scenario "with all fields filled in, using existing topic" do
          given_a_post_already_exists
          when_i_create_a_post
          and_i_select_an_existing_topic
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
      and_i_fill_in_all_the_fields
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

  def when_i_create_a_post
    visit new_post_path
  end

  def and_i_fill_in_all_the_fields
    fill_in "Title", with: "I am the Black Knight! I am invincible!"
    fill_in "Body", with: "How appropriate. You fight like a cow."
    fill_in "New topic", with: "Famous historical battles"

    and_submit_the_post
  end

  def then_the_page_should_display_the_post
    post = Post.last
    expect(page.text).to include post.title,
                                 post.topic,
                                 post.body
  end

  def and_the_post_count_should_now_be(num)
    expect(Post.count).to eq num
  end

  def and_submit_the_post
    clickee = current_path.include?('edit') ? 'Update Post' : 'Create Post'
    click_button clickee
  end

#####

  def given_a_post_already_exists
    post_1
  end

  let(:post_1) { FactoryGirl.create(:post, topic: "Blade running") }

  def and_i_select_an_existing_topic
    fill_in "Title", with: "Some gibberish"
    fill_in "Body", with: "Some more gibberish"
    find('#topic-select').select Post.first.topic

    and_submit_the_post
  end

####

  def then_the_page_should_display_errors
    expect(page.text).to include "Title can't be blank",
                                 "Body can't be blank",
                                 "Topic can't be blank"
  end

####

  def when_i_edit_a_post
    visit edit_post_path(post_1)
  end

  def and_i_remove_fields
    fill_in "Title", with: ""
    fill_in "Body", with: ""
    find('#topic-select').select ""
  end

####

  def given_multiple_posts_exist
    post_1
    post_2
  end

  def when_i_visit_the_homepage
    visit root_path
  end

  def then_i_should_see_each_post_listed_under_its_topic
    within("#blade-running") do
      expect(page).to have_content post_1.title
      expect(page).to have_text Date.today
    end

    within("#dreaming-of-electric-sheep") do
      expect(page).to have_content post_2.title
      expect(page).to have_text yesterday
    end
  end

  let(:yesterday) { Date.today - 1.day }
  let(:post_2) { FactoryGirl.create(:post, topic: "Dreaming of electric sheep", created_at: yesterday) }

####

  def then_i_should_be_able_to_navigate_to_the_post
    click_link post_1.title
    expect(page).to have_content post_1.title
    expect(page).to have_link "Edit post"
  end

####

  def when_i_view_the_post
    visit post_path(post_1)
  end

  def then_i_should_be_able_to_delete_it
    click_link "Delete post"
    expect(current_path).to eq "/"
    and_the_post_count_should_now_be(0)
  end
end
