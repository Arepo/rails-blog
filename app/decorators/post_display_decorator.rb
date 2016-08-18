class PostDisplayDecorator
  attr_reader :post

  def initialize(post)
    @post = post
  end

  def method_missing(method, *args)
    post.public_send(method, *args)
  end

  def title
    markdown.render(post.title).html_safe
  end

  def body
    markdown.render(post.body).html_safe
  end

  def topic
    markdown.render(post.topic).html_safe
  end

  def to_s
    # TODO Check if there's a more Railsy way of making this play nicely with path helpers
    post.id.to_s
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
