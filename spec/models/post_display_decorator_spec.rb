require 'rails_helper'

describe PostDisplayDecorator do
  let(:post) do
    Post.new(
      title: "Reasons why I'm **better** than Neil",
      body: "* I make seven layer bean dip of the gods" << "\n* I’m also in Halo 3 What are the odds?",
      topic: 'Important _Sience_!'
    )
  end

  let(:decorator) { PostDisplayDecorator.new(post) }

  it 'Converts title, body and topic to markdown' do
    expect(decorator.title).to include "<strong>better</strong>"
    expect(decorator.body).to include  "<ul>",
                                  "<li>I make seven layer bean dip of the gods</li>",
                                  "<li>I’m also in Halo 3 What are the odds?</li>"
    expect(decorator.topic).to include "<em>Sience</em>"
  end

  it 'Can pass methods directly to post' do
    expect(decorator.call_original(:title)).to eq post.title
  end
end
