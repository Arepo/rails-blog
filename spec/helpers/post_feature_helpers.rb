module PostFeatureHelpers

  def when_i_create_a_post
    visit new_post_path
  end

  def and_i_submit_all_the_fields
    and_i_fill_in_all_the_fields
    and_submit_the_post
  end

  def then_the_page_should_display_the_post
    post = Post.last
    expect(page.text).to include post.title,
                                 post.topic,
                                 post.body
  end

  def and_the_post_count_should_now_be(num)
    expect(Post.count).to eq num
  end

  def and_i_fill_in_all_the_fields
    fill_in "Title", with: "I am the Black Knight! I am invincible!"
    fill_in "Body", with: "How appropriate. You fight like a cow."
    fill_in "New topic", with: "Famous historical battles"
  end

  def and_submit_the_post
    clickee = current_path.include?('edit') ? 'Update Post' : 'Create Post'
    click_button clickee
  end

#####

  def given_a_post_already_exists
    post_1
  end

  def and_i_submit_an_existing_topic
    and_i_select_an_existing_topic
    and_submit_the_post
  end

  def and_i_select_an_existing_topic
    fill_in "Title", with: "Some gibberish"
    fill_in "Body", with: "Some more gibberish"
    find('#topic-select').select Post.first.topic
  end

  def post_1
    @post_1 ||= FactoryGirl.create(:post, topic: "Blade running")
  end

####

  def given_another_author_exists
    other_author
  end

  def and_i_submit_a_post_with_the_other_author
    when_i_create_a_post
    and_i_fill_in_all_the_fields
    select other_author.name, from: 'Co-author'
    and_submit_the_post
  end

  def then_we_should_both_be_authors_of_the_post
    expect(Post.last.authors).to include author,
                                         other_author
  end

  def other_author
    @other_author ||= FactoryGirl.create :author
  end

####

  def given_a_post_with_markdown
    post_1.update title: "Highly *emphatic*", body: '## Headonistic'
  end

  def then_it_should_display_with_html
    expect(page.body).to include "Highly <em>emphatic</em>",
                                 "<h2>Headonistic</h2>"
  end

####

  def then_the_page_should_display_errors
    expect(page.text).to include "Title can't be blank",
                                 "Body can't be blank",
                                 "Topic can't be blank"
  end

####

  def when_i_edit_a_post
    visit edit_post_path(post_1)
  end

  def and_i_remove_fields
    fill_in "Title", with: ""
    fill_in "Body", with: ""
    find('#topic-select').select ""
  end

####

  def given_a_post_with_two_tags_exists
    post_1.tags << Tag.create(name: "Tag2")
  end

  def and_i_delete_a_tag
    page.uncheck Tag.first.name
    and_submit_the_post
  end

  def then_the_post_should_have_just_the_remaining_tag
    expect(post_1.tags.count).to be 1
    expect(post_1.tags.first.name).to eq "Tag2"
  end

####

  def given_multiple_posts_exist
    post_1
    post_2
  end

  def when_i_visit_the_homepage
    visit root_path
  end

  def then_i_should_see_each_post_listed_under_its_topic
    within("#blade-running") do
      expect(page).to have_content post_1.title
      expect(page).to have_text Date.today
    end

    within("#dreaming-of-electric-sheep") do
      expect(page).to have_content post_2.title
      expect(page).to have_text yesterday
    end
  end

  def yesterday
    @yesterday ||= Date.today - 1.day
  end

  def post_2
    @post_2 ||= FactoryGirl.create(:post, topic: "Dreaming of electric sheep", created_at: yesterday)
  end

####

  def then_i_should_be_able_to_navigate_to_the_post
    click_link post_1.title
    expect(page).to have_content post_1.title
    expect(page).to have_link "Edit post"
  end

####

  def when_i_view_the_post
    visit post_path(post_1)
  end

  def then_i_should_be_able_to_delete_it
    click_link "Delete post"
    expect(current_path).to eq "/"
    and_the_post_count_should_now_be(0)
  end

  def and_see_confirmation_of_the_deletion
    expect(page).to have_content "#{post_1.title} has been deleted"
  end

####

  def then_i_should_not_have_the_option_to_create_a_post
    expect(page).not_to have_content "New post"
  end

####

  def then_i_should_not_be_able_to_edit_or_delete_it
    expect(page).not_to have_content "Edit post"
    expect(page).not_to have_content "Delete post"
  end
end
