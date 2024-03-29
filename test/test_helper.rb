ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  ActionDispatch::IntegrationTest.include Turbo::TestAssertions

  # Correctly login the user
  def login
    username = Rails.application.credentials.auth[:login]
    password = Rails.application.credentials.auth[:plain_password_for_tests]
    post user_sessions_url(username:, password:)
  end
end
