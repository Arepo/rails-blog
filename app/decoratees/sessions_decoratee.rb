class SessionsDecoratee
  attr_accessor :controller

  def initialize(controller = :fake_controller)
    self.controller = controller
  end

  def log_in(author)
    controller.session[:author_id] = author.id
  end

  def current_author
    @current_author ||= Author.find_by(id: controller.session[:author_id])
  end

  def logged_in?
    !!current_author
  end
end
