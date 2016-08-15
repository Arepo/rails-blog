class SessionsController < ApplicationController
  def new
  end

  def create
    author = Author.find_by email: params[:session][:email]
    if author && author.authenticate(params[:session][:password])
      log_in author
      flash.notice = "Hello #{author.name}, you shining pinnacle of evolution"
      redirect_to root_path
    else
      flash.now[:danger] = 'No author found with that username/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    flash.notice = "I thought we had a thing, brah :("
    redirect_to root_path
  end
end
