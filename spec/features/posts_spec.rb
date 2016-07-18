require "rails_helper"

describe "Posts" do
  describe "Creating a post" do
    scenario "can create a post" do
      visit "/"
      click_link "New post"
      fill_in :title, with: "Some gibberish"
      fill_in :body, with: "Some more gibberish"
      click_button "Submit"
      expect(page).to have_content "Some gibberish"
      expect(page).to have_content "Some more gibberish"
      expect(Post.count).to eq 1
    end
  end
end
