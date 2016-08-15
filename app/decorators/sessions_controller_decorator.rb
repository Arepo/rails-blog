class SessionsControllerDecorator
  attr_accessor :controller

  def initialize(controller)
    self.controller = controller
  end

  def method_missing(method, *args, &block)
    controller.send(method, *args, &block)
  end

  def respond_to?(method, include_private = false)
    super || controller.respond_to?(method)
  end

  def log_in(user)

  end
end
