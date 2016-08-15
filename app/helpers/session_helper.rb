module SessionHelper

  def log_in(author)
    session[:author_id] = author.id
  end

  def current_user
    @current_user ||= Author.find_by id: session[:author_id]
  end

  def log_out
    session.delete :author_id
    @current_user = nil
  end
end
