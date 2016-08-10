require 'rails_helper'

describe "Tags" do

  context "Home page" do
    scenario "Displaying all tags" do
      visit '/'
      tags = Tag.names

      expect(page.text).to include tags
    end
  end
end
