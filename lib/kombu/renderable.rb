# frozen_string_literal: true

require_relative "errors"

module Kombu
  module Renderable
    include ActionView::Helpers::TagHelper
    extend ActiveSupport::Concern

    included do
      helper_method :kombu_component_tag, :kombu_javascript_entry_tag, :kombu_stylesheet_entry_tag
    end

    def kombu_render_component(component_name, entry_name: nil, mount_element_id: nil, attributes: {})
      @kombu_component = component_name
      @kombu_attributes = attributes
      @kombu_entry = entry_name.presence || kombu_default_entry
      @kombu_mount_element_id = mount_element_id.presence || kombu_default_mount_element_id
      render kombu_render_option
    rescue => error
      raise Kombu::RenderError, error.message
    end

    def kombu_component_tag
      tag(@kombu_component, @kombu_attributes)
    end

    def kombu_javascript_entry_tag
      raise_kombu_render_error_not_configured("javascript_entry_tag_proc") if kombu_javascript_entry_tag_proc.nil?
      instance_exec(&kombu_javascript_entry_tag_proc)
    end

    def kombu_stylesheet_entry_tag
      raise_kombu_render_error_not_configured("stylesheet_entry_tag_proc") if kombu_stylesheet_entry_tag_proc.nil?
      instance_exec(&kombu_stylesheet_entry_tag_proc)
    end

    private

    def kombu_default_entry
      File.join(controller_name, action_name)
    end

    def kombu_render_option
      {inline: kombu_template, layout: true}
    end

    def kombu_template
      kombu_app_config.default_entry_view_template
    end

    def kombu_javascript_entry_tag_proc
      kombu_app_config.javascript_entry_tag_proc
    end

    def kombu_stylesheet_entry_tag_proc
      kombu_app_config.stylesheet_entry_tag_proc
    end

    def kombu_default_mount_element_id
      kombu_app_config.default_mount_element_id
    end

    def kombu_app_config
      @kombu_app_config ||= Rails.application.config.kombu
    end

    def raise_kombu_render_error_not_configured(config_name)
      raise Kombu::RenderError,
        "config.kombu.#{config_name} is not configured. Please set it during application initialization."
    end
  end
end
