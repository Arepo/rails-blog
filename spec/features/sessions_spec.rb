require 'rails_helper'

describe "Sessions", type: :feature do
  context "Logging in" do
    given_an_author_exists
    when_i_visit_the_author_login_page
    and_i_log_in
    then_i_should_see_a_message_confirming_login
  end

  def given_an_author_exists
    author
  end

  def when_i_visit_the_author_login_page
    visit new_session_path
  end

  def and_i_log_in
    fill_in 'Email', with: author.email
    fill_in 'Password', with: 'unbreakable'
    click_button "Log in"
  end

  def then_i_should_see_a_message_confirming_login
    expect(page).to have_content "Logged in successfully"
  end

  let(:author) { FactoryGirl.create(:author, password: 'unbreakable') }
end
