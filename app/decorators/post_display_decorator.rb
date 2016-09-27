class PostDisplayDecorator
  def self.render_multiple(strings)
    strings.map { |string| markdown.render(string).html_safe }
  end

  attr_reader :post

  def initialize(post)
    @post = post
  end

  def method_missing(method, *args)
    post.public_send(method, *args)
  end

  def body
    markdown.render(post.body).html_safe
  end

  def call_original(method)
    post.public_send(method)
  end

  def list_tags
    markdown.render(post.list_tags).html_safe
  end

  def title
    markdown.render(post.title).html_safe
  end

  def to_param
    # Hack for friendly_id gem
    post.to_param
  end

  def to_s
    # TODO Check if there's a more Railsy way of making this play nicely with path helpers
    post.id.to_s
  end

  def topic
    markdown.render(post.topic).html_safe
  end

  private

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def markdown
    self.class.markdown
  end
end
