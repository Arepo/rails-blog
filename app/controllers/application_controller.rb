class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_author
    @current_author ||= Author.find_by(id: session[:author_id])
  end

  def logged_in?
    !!current_author
  end
end
