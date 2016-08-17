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
      and_the_site_should_not_keep_me_logged_in
    end

    scenario "Permanently" do
      when_i_visit_the_author_login_page
      and_i_log_in_permanently
      then_the_site_should_keep_me_logged_in
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
end
