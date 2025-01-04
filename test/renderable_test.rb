# frozen_string_literal: true

require "test_helper"

class KombuTestsController < ApplicationController
  include Kombu::Renderable

  def index
  end
end

class RenderableTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.configure do
      config.kombu.javascript_entry_tag_proc = -> { helpers.tag.div("sample_js_entry_tag", id: "entry-js") }
      config.kombu.stylesheet_entry_tag_proc = -> { helpers.tag.div("sample_css_entry_tag", id: "entry-css") }
    end

    draw_test_routes do
      get "/kombu_tests", to: "kombu_tests#index"
    end
  end

  teardown do
    reload_routes!
  end

  test "render component with default" do
    KombuTestsController.define_method(:index) do
      kombu_render_component("my-component")
    end
    get "/kombu_tests"
    assert_response :success
    assert_select "div#entry-js"
    assert_select "div#entry-css"
    assert_select "div#app my-component"
  end

  test "render any component with html attributes" do
    KombuTestsController.define_method(:index) do
      kombu_render_component(
        "my-component",
        attributes: {
          id: "test-component",
          title: "sample title"
        }
      )
    end
    get "/kombu_tests"
    assert_response :success
    assert_select "my-component#test-component"
    assert_select "my-component[title='sample title']"
  end

  test "not render component with nil" do
    KombuTestsController.define_method(:index) do
      kombu_render_component(nil)
    end
    get "/kombu_tests"
    assert_response :success
    assert_select "div#app"
    assert_select("my-component", false)
  end

  test "snapshot" do
    KombuTestsController.define_method(:index) do
      kombu_render_component(
        "my-component",
        attributes: {
          id: "test-component",
          title: "sample title",
          ":message": {title: "hello", body: "kombu"}.to_json,
          ":items": [{id: 1, title: "item1"}, {id: 2, title: "item2"}].to_json
        }
      )
    end
    get "/kombu_tests"
    assert_response :success
    render_result = response.body.gsub(/\s+/, "")
    snapshot = <<~HTML.gsub(/\s+/, "")
      <!DOCTYPE html>
      <html>
        <head>
          <title>Dummy</title>
          <meta name="viewport" content="width=device-width,initial-scale=1">
            <div id="entry-css">sample_css_entry_tag</div>
        </head>
        <body>
          <div id="app">
            <my-component
              id="test-component"
              title="sample title"
              :message="{&quot;title&quot;:&quot;hello&quot;,&quot;body&quot;:&quot;kombu&quot;}"
              :items="[{&quot;id&quot;:1,&quot;title&quot;:&quot;item1&quot;},{&quot;id&quot;:2,&quot;title&quot;:&quot;item2&quot;}]"
            />
          </div>
          <div id="entry-js">sample_js_entry_tag</div>
        </body>
      </html>
    HTML
    assert_equal(snapshot, render_result)
  end
end
