# frozen_string_literal: true

Rails.application.configure do
  # NOTE: custom options
  config.kombu.default_mount_element_id = "app"
  config.kombu.javascript_entry_tag_proc = -> { helpers.tag.div("sample_js_entry_tag") }
  config.kombu.stylesheet_entry_tag_proc = -> { helpers.tag.div("sample_css_entry_tag") }
end
