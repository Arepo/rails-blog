class ApplicationController < ActionController::Base
  before_action :find_faq
  protect_from_forgery prepend: true, with: :exception

  include SessionHelper

  private

  def find_faq
    @faq = Post.find_by(title: "Valence utilitarianism FAQ")
  end
end
