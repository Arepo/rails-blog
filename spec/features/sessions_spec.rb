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

  scenario "Logging out" do
    given_i_am_logged_in
    when_i_log_out
    then_i_should_see_confirmation_of_logging_out
  end

  def given_an_author_exists
    author
  end

  def when_i_visit_the_author_login_page
    visit login_path
  end

  def and_i_log_in_successfully
    fill_in 'Email', with: author.email
    fill_in 'Password', with: 'unbreakable!'
    click_button "Log in"
  end

  def then_i_should_see_a_message_confirming_login
    expect(page).to have_content "Hello #{author.name}, you shining pinnacle of evolution"
  end

  let(:author) { FactoryGirl.create(:author, password: 'unbreakable!') }

####

  def and_i_log_in_unsuccessfully
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'Faker::Areponet.probably_not_a_real_password'
    click_button "Log in"
  end

  def then_i_should_see_a_message_denying_login
    expect(page).to have_content "No author found with that username/password combination"
  end

####

  def given_i_am_logged_in
    page.set_rack_session author_id: author.id
    visit root_path
  end

  def when_i_log_out
    click_link 'Log out'
  end

  def then_i_should_see_confirmation_of_logging_out
    expect(page).to have_content "I thought we had a thing, brah :("
  end
end
