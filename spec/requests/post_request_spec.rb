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
      xscenario "Cannot create a post" do
        expect { post(
          new_posts_path,
          title: "Sneaky",
          body: "Robopost",
          topic: "Something terribly benign"
        ) }.not_to change { Post.count }

      end
    end

    context "Trying to changing existing posts" do
      let(:post) { FactoryGirl.create :post, title: "Wholesome sermon on honesty" }

      scenario "Cannot update a post" do
        patch(
          post_path(post),
          title: "Ha! Ur website iz hacked!"
        )

        expect(post.reload.title).to eq 'Wholesome sermon on honesty'
      end

      scenario "Cannot delete a post" do
        delete(
          post_path(post)
        )

        expect(post).not_to be_persisted
      end
    end
  end
end
