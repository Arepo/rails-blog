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

  describe "Displaying all posts" do
    let!(:post_1) { FactoryGirl.create(:post) }
    let!(:post_2) { FactoryGirl.create(:post) }

    scenario "displays all posts" do
      visit "/"
      expect(page).to have_content post_1.title
      expect(page).to have_content post_1.body
      expect(page).to have_content post_2.title
      expect(page).to have_content post_2.body
    end
  end
end
