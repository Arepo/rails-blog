class PostDisplayDecorator
  include ActionView::Helpers::SanitizeHelper

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
    html = markdown.render(post.body)
    html.gsub(/(<h[3-5]>)(.*)(<\/h[3-5])/) do
      # Catches h3, h4 and h5 tags and inserts an anchor between them
      uri_safe_header = strip_tags($2).parameterize
      $1 + "<a id=\"#{uri_safe_header}\">" + $2 + '</a>' + $3
    end.html_safe
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

  def add_anchors(opening_tag, contents, closing_tag)
    uri_safe_header = strip_tags(contents).parameterize
    opening_tag + "<a id=\"#{uri_safe_header}\">" + contents + '</a>' + closing_tag
  end

  def markdown
    self.class.markdown
  end
end
