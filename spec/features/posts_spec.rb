require "rails_helper"

describe "Posts" do
  describe "Creating a post" do
    context "successfully" do
      context "with new topic" do
        scenario "with all fields filled in, creating a new topic" do
          visit new_post_path
          fill_in "Title", with: "Some gibberish"
          fill_in "Body", with: "Some more gibberish"
          fill_in 'New topic', with: "Something terribly profound"

          click_button "Create Post"

          expect(page.text).to include "Some gibberish",
                                       "Some more gibberish",
                                       "Something terribly profound"
          expect(Post.count).to eq 1
        end
      end

      context "in existing topic" do
        let!(:ur_post) { FactoryGirl.create :post }

        scenario "with all fields filled in, using existing topic" do
          visit new_post_path
          fill_in "Title", with: "Some gibberish"
          fill_in "Body", with: "Some more gibberish"

          find('#topic-select').select ur_post.topic
          click_button "Create Post"

          expect(page.text).to include "Some gibberish", "Some more gibberish", ur_post.topic
          expect(Post.count).to eq 2
        end
      end
    end

    context "unsuccessfully" do
      before do
        visit new_post_path
      end

      scenario "with fields missing" do
        click_button "Create Post"

        expect(Post.count).to eq 0
        expect(page.text).to include "Title can't be blank",
                                     "Body can't be blank",
                                     "Topic can't be blank"
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
    let!(:post_1) { FactoryGirl.create(:post, topic: "Blade running") }

    let!(:post_2) do
      FactoryGirl.create(:post, topic: "Dreaming of electric sheep", created_at: yesterday)
    end
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
