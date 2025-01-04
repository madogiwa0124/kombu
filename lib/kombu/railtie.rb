# frozen_string_literal: true

require "rails/railtie"
require_relative "configration"

module Kombu
  class Railtie < ::Rails::Railtie
    MOUNT_ELEMENT_ID = "app"
    ENTRY_VIEW_TEMPLATE = <<~ERB
      <div id="<%= @kombu_mount_element_id %>">
        <%= kombu_component_tag %>
      </div>
      <% content_for :stylesheet do %>
        <%= kombu_stylesheet_entry_tag %>
      <% end %>
      <% content_for :javascript do %>
        <%= kombu_javascript_entry_tag %>
      <% end %>
    ERB

    config.kombu = Configration.new
    config.kombu.default_mount_element_id = MOUNT_ELEMENT_ID
    config.kombu.default_entry_view_template = ENTRY_VIEW_TEMPLATE
  end
end
