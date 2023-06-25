require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "kombu"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
  end
end
