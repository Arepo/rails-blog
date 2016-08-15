class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :create_helper

  delegate :log_in, :current_author, :logged_in?, to: :helper

  attr_reader :helper

  private

  def create_helper
    @helper = SessionsDecoratee.new(self)
  end
end
