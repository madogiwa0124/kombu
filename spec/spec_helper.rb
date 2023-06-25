# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
require_relative "../lib/kombu/test/rspec/matchers/component_rendered_matcher"
require "rspec/rails"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include Kombu::RSpec::Matchers::ComponentRenderedMatcher, type: :request
end
