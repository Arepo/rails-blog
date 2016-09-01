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

  def self.render_multiple(strings)
    strings.map { |string| markdown.render(string).html_safe }
  end

  private

  class RenderWithoutWrap < Redcarpet::Render::HTML
    def postprocess(full_document)
      Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document).try(:[], 1) || full_document
    end
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(RenderWithoutWrap, autolink: true, tables: true)
  end

  def markdown
    self.class.markdown
  end
end
