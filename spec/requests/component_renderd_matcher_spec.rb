require "spec_helper"

describe "GET /articles", type: :request do
  before { get articles_path }

  it "Specific arguments must be passed to kombu_render_component." do
    title = "Articles"
    articles = [{id: 1, title: "artile1", body: "body1"}, {id: 2, title: "artile2", body: "body2"}]
    expect(controller).to kombu_component_rendered("article-index-page", attributes: {title: title, ":articles": articles.to_json})
  end
end
