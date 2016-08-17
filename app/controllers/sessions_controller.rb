class SessionsController < ApplicationController
  def new
  end

  def create
    author = Author.find_by email: params[:session][:email]
    if author && author.authenticate(params[:session][:password])
      log_in author
      audit_cookie_for author
      flash.notice = "Hello #{author.name}, you sexy pinnacle of evolution"
      redirect_to root_path
    else
      flash.now[:danger] = 'No author found with that username/password combination'
      render 'new'
    end
  end

  def destroy
    if logged_in?
      log_out
      flash.notice = "I name thee BETRAYER!"
    end
    redirect_to root_path
  end

  def audit_cookie_for author
    params[:session][:remember_me] == '1' ? remember(author) : forget(author)
  end
end
