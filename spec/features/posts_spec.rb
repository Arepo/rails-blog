require "rails_helper"

describe "Posts" do
  describe "Creating a post" do
    before do
      visit "/"
      click_link "New post"
    end

    context "successfully" do
      scenario "with all fields filled in" do
        fill_in "Title", with: "Some gibberish"
        fill_in "Body", with: "Some more gibberish"
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
      expect(page).to have_content post.title
    end
  end

  describe "Displaying all posts" do
    let!(:post_1) { FactoryGirl.create(:post) }
    let!(:post_2) { FactoryGirl.create(:post, created_at: yesterday) }
    let(:yesterday) { Date.today - 1.day }

    scenario "All post titles and creation dates are displayed" do
      visit "/"

      expect(page).to have_content post_1.title
      expect(page).to have_content post_2.title

      [Date.today, yesterday].each do |date|
        expect(page).to have_text date
      end
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
