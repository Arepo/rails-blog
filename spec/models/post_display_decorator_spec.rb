require 'rails_helper'

describe PostDisplayDecorator do
  let(:post) do
    Post.new(
      title: "Reasons why I'm **better** than Neil",
      topic: 'Important _Sience_!',
      body: <<~BODY
              ### Papa header
              #### Mama header
              ##### Baby header
              * I make seven layer bean dip of the gods
              * I’m also in Halo 3 What are the odds?
            BODY
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

  it 'Automatically converts h3s, h4s, and h5s to self-titled anchors' do
    expect(decorator.body).to include '<h3><a id="papa-header">Papa header</a></h3>',
                                      '<h4><a id="mama-header">Mama header</a></h4>',
                                      '<h5><a id="baby-header">Baby header</a></h5>'
  end
end
