require "rails_helper"

describe "Posts" do
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
    # let(:post) { FactoryGirl.create(:post, body: "I'm the black knight! I'm invincible!") }

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
    let!(:post_1) { FactoryGirl.create(:post, topic: "Blade running") }

    let!(:post_2) do
      FactoryGirl.create(:post, topic: "Dreaming of electric sheep", created_at: yesterday)
    end

    let(:yesterday) { Date.today - 1.day }

    before { visit "/" }

    scenario "All post titles and creation dates are listed under a primary topic heading" do
      within("#blade-running") do
        expect(page).to have_content post_1.title
        expect(page).to have_text Date.today
      end

      within("#dreaming-of-electric-sheep") do
        expect(page).to have_content post_2.title
        expect(page).to have_text yesterday
      end
    end
  end

  describe "Viewing a single post" do
    let!(:post) { FactoryGirl.create(:post) }

    scenario "Navigating from the index page" do
      visit "/"

      click_link post.title
      expect(page).to have_content post.title
      expect(page).to have_link "Edit post"
    end
  end

  describe "Deleting a post" do
    let(:post) { FactoryGirl.create(:post) }

    before do
      visit post_path(post)
      click_link "Delete post"
    end

    scenario "removes it from the db" do
      expect(current_path).to eq "/"
      and_the_post_count_should_now_be(0)
    end
  end

  def and_i_remove_fields
    fill_in "Title", with: ""
    fill_in "Body", with: ""
    find('#topic-select').select ""
  end

  def given_a_post_already_exists
    FactoryGirl.create :post
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

  let(:post) { Post.last }

  def when_i_edit_a_post
    visit edit_post_path(post)
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

  def and_i_select_an_existing_topic
    fill_in "Title", with: "Some gibberish"
    fill_in "Body", with: "Some more gibberish"
    find('#topic-select').select Post.first.topic

    and_submit_the_post
  end

  def and_submit_the_post
    clickee = current_path.include?('edit') ? 'Update Post' : 'Create Post'
    click_button clickee
  end

  def then_the_page_should_display_errors
    expect(page.text).to include "Title can't be blank",
                                 "Body can't be blank",
                                 "Topic can't be blank"
  end
end
