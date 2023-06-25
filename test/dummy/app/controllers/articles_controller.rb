class ArticlesController < ApplicationController
  include Kombu::Renderable

  def index
    @title = "Articles"
    @articles = [{id: 1, title: "artile1", body: "body1"}, {id: 2, title: "artile2", body: "body2"}]
    kombu_render_component("article-index-page", attributes: {title: @title, ":articles": @articles.to_json})
  end
end
