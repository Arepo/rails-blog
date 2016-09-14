class ApplicationController < ActionController::Base
  before_action :find_faq
  protect_from_forgery with: :exception

  include SessionHelper

  private

  def find_faq
    @faq = Post.find_by(title: "Valence utilitarianism FAQ")
  end
end
