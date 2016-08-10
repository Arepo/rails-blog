# require 'rails_helper'

# describe "Tags" do

#   context "Home page" do
#     before { FactoryGirl.create_list(:tag, 3) }

#     scenario "Displaying all tags" do
#       visit '/'
#       tags = Tag.names

#       expect(page.text).to include *tags
#     end
#   end

#   scenario "Creating a tag when creating a post" do
#     when_i_create_a_post
#   end

#   def when_i_create_a_post
#     visit new_post_path
#   end
# end
