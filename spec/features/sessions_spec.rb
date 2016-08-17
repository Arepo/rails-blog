require 'rails_helper'

describe "Sessions", type: :feature do
  context "Logging in" do
    before { given_an_author_exists }

    scenario "Unsuccessfuly" do
      when_i_visit_the_author_login_page
      and_i_log_in_unsuccessfully
      then_i_should_see_a_message_denying_login
    end

    scenario "Temporarily" do
      when_i_visit_the_author_login_page
      and_i_log_in_temporarily
      then_i_should_see_a_message_confirming_login
      and_i_should_not_have_my_session_stored_in_a_cookie
    end

    scenario "Permanently" do
      when_i_visit_the_author_login_page
      and_i_log_in_permanently
      then_i_should_have_my_session_stored_in_a_cookie
    end
  end

  context "Logging out" do
    scenario "Logging out" do
      given_i_am_logged_in
      when_i_log_out
      then_i_should_see_confirmation_of_logging_out
    end

    scenario "Trying to log out twice" do
      given_i_am_logged_in
      when_i_log_out_twice
      then_nothing_should_go_wrong
    end
  end

  def when_i_visit_the_author_login_page
    visit login_path
  end

  def and_i_log_in_unsuccessfully
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'Faker::Areponet.probably_not_a_real_password'
    click_button 'Log in'
  end

  def then_i_should_see_a_message_denying_login
    expect(page).to have_content "No author found with that username/password combination"
  end

####

  def given_an_author_exists
    author
  end

  def and_i_log_in_temporarily
    fill_in 'Email', with: author.email
    fill_in 'Password', with: 'unbreakable!'
    click_button 'Log in'
  end

  def then_i_should_see_a_message_confirming_login
    expect(page).to have_content "Hello #{author.name}, you sexy pinnacle of evolution"
  end

  def and_i_should_not_have_my_session_stored_in_a_cookie
    expect(remember_token).to be nil
  end

  let(:remember_token) { page.driver.request.cookies['remember_token'] }
  let(:author) { FactoryGirl.create(:author, password: 'unbreakable!') }

####

  def and_i_log_in_permanently
    fill_in 'Email', with: author.email
    fill_in 'Password', with: 'unbreakable!'
    check 'Remember me'
    click_button 'Log in'
  end

  def then_i_should_have_my_session_stored_in_a_cookie
    expect(remember_token).to be_present
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
    expect(page).to have_content "I name thee BETRAYER!"
  end

####

  def when_i_log_out_twice
    click_link 'Log out'
    page.driver.delete logout_path
  end

  def then_nothing_should_go_wrong
    # No-op
  end
end
