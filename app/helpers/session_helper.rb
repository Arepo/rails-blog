module SessionHelper

  def log_in author
    session[:author_id] = author.id
  end

  def current_user
    @current_user ||= if author_id = session[:author_id]
      Author.find_by id: author_id
    else
      attempt_log_in_from_cookie
    end
  end

  def log_out
    session.delete :author_id
    @current_user = nil
  end

  def remember author
    author.remember
    cookies.permanent.signed[:author_id] = author.id
    cookies.permanent[:remember_token] = author.remember_token
  end

  private

  def attempt_log_in_from_cookie
    author_id = cookies.signed[:author_id]
    author = Author.find_by id: author_id

    if author && author.authenticated?(cookies[:remember_token])
      log_in author
    end
  end
end
