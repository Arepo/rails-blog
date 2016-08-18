require 'rails_helper'

describe PostDisplayDecorator do
  it 'Converts title, body and topic to markdown' do
    post = Post.new(
      title: "Reasons why I'm **better** than Neil",
      body: "* I make seven layer bean dip of the gods" << "\n* I’m also in Halo 3 What are the odds?",
      topic: 'Important _Sience_!'
    )
    decorator = PostDisplayDecorator.new(post)

    expect(decorator.title).to include "<strong>better</strong>"
    expect(decorator.body).to include  "<ul>",
                                  "<li>I make seven layer bean dip of the gods</li>",
                                  "<li>I’m also in Halo 3 What are the odds?</li>"
    expect(decorator.topic).to include "<em>Sience</em>"
  end
end
