require 'rails_helper'

describe 'User management', type: :request do
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
