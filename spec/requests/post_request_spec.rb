require 'rails_helper'

describe 'Author management', type: :request do

  context "Tracking existing authors" do
    scenario "Remembering users between sessions" do
      # TODO make this test less of a hack
      allow(SecureRandom).to receive(:urlsafe_base64).and_return "LptYPGADzd97e3Bd1c-n8g"
      author = FactoryGirl.create :author
      author.remember

      allow_any_instance_of(ActionDispatch::Cookies::SignedCookieJar).to receive(:[]).and_return author.id
      cookies['remember_token'] = 'LptYPGADzd97e3Bd1c-n8g'
      get '/'
      expect(response.body).to include('Log out')
    end
  end

  context "Attempting db changes while not logged in" do
    context "New post" do
      scenario "Cannot create a post" do
        expect do
          post(
            posts_path,
            params: {
              post: { title: "Sneaky",
                body: "Robopost",
                topic: "Something terribly benign"
              },
              tags: { "Acquiring tag on seditious blogger" => 1, new_tags: "" }
            }
          )
        end.not_to change { Post.count }
      end
    end

    context "Trying to changing existing posts" do
      let!(:post) { FactoryGirl.create :post, title: "Wholesome sermon on honesty" }

      scenario "Cannot update a post" do
        expect do
          patch(
            post_path(post),
            params: {
              post: { title: "Ha! Ur website iz hacked!" }
            }
          )
        end.not_to change { post.reload.title }
      end

      scenario "Cannot delete a post" do
        expect { delete(post_path(post)) }.not_to change { Post.count }
      end
    end
  end
end
