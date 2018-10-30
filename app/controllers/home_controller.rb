require 'permissions'
class HomeController < ApplicationController
  include Permissions
  def index
  end
end
