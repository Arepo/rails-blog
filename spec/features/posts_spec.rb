require "rails_helper"

describe "Posts" do
  describe "Creating a post" do
    let!(:topic_1) { FactoryGirl.create(:topic) }

    before do
      visit "/"
      click_link "New post"
    end

    context "successfully" do
      scenario "with all fields filled in" do
        fill_in "Title", with: "Some gibberish"
        fill_in "Body", with: "Some more gibberish"
        fill_in "Topic", with: topic_1.title
        click_button "Create Post"

        expect(page).to have_content "Some gibberish"
        expect(page).to have_content "Some more gibberish"
        expect(Post.count).to eq 1
      end
    end

    context "unsuccessfully" do
      scenario "with an empty title" do
        fill_in "Body", with: "Gibberish without title"
        click_button "Create Post"

        expect(Post.count).to eq 0
        expect(page).to have_content "Title can't be blank"
      end

      scenario "cannot create a post with an empty body" do
        fill_in "Title", with: "Gibberish without body"
        click_button "Create Post"

        expect(Post.count).to eq 0
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe "Editing a post" do
    let(:post) { FactoryGirl.create(:post, body: "I'm the black knight! I'm invincible!") }

    before do
      visit post_path(post)
      click_link "Edit post"
    end

    scenario "Viewing current content" do
      expect(page).to have_content post.title
      expect(page).to have_content post.body
    end

    scenario "successfully" do
      fill_in "Body", with: "How appropriate. You fight like a cow."
      click_button "Save changes"
      expect(page).to have_content "How appropriate. You fight like a cow."
    end

    scenario "unsuccessfully" do
      fill_in "Body", with: ""
      click_button  "Save changes"
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe "Displaying all posts" do
    let!(:post_1) { FactoryGirl.create(:post, topic: topic_1) }
    let(:topic_1) { FactoryGirl.create(:topic, title: "Blade running") }

    let!(:post_2) { FactoryGirl.create(:post, topic: topic_2, created_at: yesterday) }
    let!(:topic_2) { FactoryGirl.create(:topic, title: "Dreaming of electric sheep") }
    let(:yesterday) { Date.today - 1.day }

    before do
      visit "/"
    end

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
      expect(Post.count).to eq 0
    end
  end
end
