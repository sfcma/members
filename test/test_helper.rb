ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # This should actually be done via a method stub rather than redefining the method
  def with_logged_in_user
    ApplicationController.send(:define_method, :authenticate_user!) do
      nil
    end
  end
end
