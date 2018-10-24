# customize session controller
class SessionsController < Devise::SessionsController
  def create
    super
  end
end