# frozen_string_literal: true

module Kombu
  module RSpec
    module Matchers
      module ComponentRenderedMatcher
        def kombu_component_rendered(component, entry: nil, mount_element_id: nil, attributes: {})
          Matcher.new(component, entry: entry, mount_element_id: mount_element_id, attributes: attributes)
        end

        class Matcher
          def initialize(component, entry: nil, mount_element_id: nil, attributes: {})
            @expected_component = component
            @expected_entry = entry
            @expected_mount_element_id = mount_element_id
            @expected_attributes = attributes
          end

          def matches?(controller)
            set_actual_avaliables(controller)
            component_match? && entry_match? && mount_element_id_match? && attributes_match?
          end

          def failure_message
            return failure_component_message unless component_match?
            return failure_attributes_message unless attributes_match?
            return failure_entry_message unless entry_match?
            failure_mount_element_id_message unless mount_element_id_match?
          end

          private

          def failure_component_message
            "Expected component #{@expected_component} to match #{@actual_component}."
          end

          def failure_attributes_message
            expected = pretty_json(@expected_attributes.to_json)
            actual = pretty_json(@actual_attributes.to_json)
            "Expected component attributes #{expected} to match #{actual}."
          end

          def failure_entry_message
            "Expected entry #{@expected_entry} to match #{@actual_entry}."
          end

          def failure_mount_element_id_message
            "Expected mount element id #{@expected_mount_element_id} to match #{@actual_mount_element_id}."
          end

          def component_match?
            @expected_component == @actual_component
          end

          def attributes_match?
            @expected_attributes == @actual_attributes
          end

          def entry_match?
            return true if @expected_entry.nil?
            @expected_entry == @actual_entry
          end

          def mount_element_id_match?
            return true if @expected_mount_element_id.nil?
            @expected_mount_element_id == @actual_mount_element_id
          end

          def set_actual_avaliables(actual) # rubocop:disable Naming/AccessorMethodName
            @actual_component = actual.instance_variable_get(:@kombu_component)
            @actual_attributes = actual.instance_variable_get(:@kombu_attributes)
            @actual_entry = actual.instance_variable_get(:@kombu_entry)
            @actual_mount_element_id = actual.instance_variable_get(:@kombu_mount_element_id)
          end

          def pretty_json(str)
            JSON.pretty_generate(JSON.parse(str))
          end
        end
      end
    end
  end
end
