# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
require "rails/test_help"

# NOTE: enabeled to support routes for test.
require "support/routes_helper"
class ActionDispatch::IntegrationTest
  include RoutesHelpers
end
