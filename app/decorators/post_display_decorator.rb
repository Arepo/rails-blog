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
    html.gsub(/(<h3>)(.*)(<\/h3)/) do
      # TODO - Try and get this into a single operation. Tried with the regex
      # /(<h3>)(.*)(<\/h3)|(<h4>)(.*)(<\/h4)|(<h5>)(.*)(<\/h5)/ but it returned the match data thus:
      # #<MatchData "<h4>Mama header</h4" 1:nil 2:nil 3:nil 4:"<h4>" 5:"Mama header" 6:"</h4" 7:nil 8:nil 9:nil>
      # for the second match, and so on for the third
      add_anchors($1, $2, $3)
    end.gsub(/(<h4>)(.*)(<\/h4)/) do
      add_anchors($1, $2, $3)
    end.gsub(/(<h5>)(.*)(<\/h5)/) do
      add_anchors($1, $2, $3)
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
