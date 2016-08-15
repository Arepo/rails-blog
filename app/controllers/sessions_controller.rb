class SessionsController < ApplicationController
  def new
  end

  def create
    author = Author.find_by email: params[:session][:email]
    if author && author.authenticate
    else
      flash.now[:danger] = 'No author found with that username/password combination'
      render 'new'
    end
  end

  def destroy
  end
end
