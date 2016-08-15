require 'rails_helper'

describe "Sessions", type: :feature do
  context "Logging in" do
    scenario "Successfully" do
      given_an_author_exists
      when_i_visit_the_author_login_page
      and_i_log_in_successfully
      then_i_should_see_a_message_confirming_login
    end

    scenario "Unsuccessfuly" do
      when_i_visit_the_author_login_page
      and_i_log_in_unsuccessfully
      then_i_should_see_a_message_denying_login
    end
  end

  def given_an_author_exists
    author
  end

  def when_i_visit_the_author_login_page
    visit login_path
  end

  def and_i_log_in_successfully
    fill_in 'Email', with: author.email
    fill_in 'Password', with: 'unbreakable'
    click_button "Log in"
  end

  def then_i_should_see_a_message_confirming_login
    expect(page).to have_content "Logged in successfully"
  end

####

  def and_i_log_in_unsuccessfully
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'Faker::Areponet.probably_not_a_real_password'
    click_button "Log in"
  end

  def then_i_should_see_a_message_denying_login
    expect(page).to have_content "No author found with that username/password combination"
  end

  let(:author) { FactoryGirl.create(:author, password: 'unbreakable') }
end
