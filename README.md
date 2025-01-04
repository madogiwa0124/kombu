# Kombu

Kombu provides the ability to render the specified component directly from the controller.

This gem may replace any javascript component except layouts in the `views` directory.

This gem was inspired by the following projects.

- [React-Rails](https://github.com/reactjs/react-rails)
- [Inertia.js Rails Adapter](https://github.com/inertiajs/inertia-rails)

## Usage

### Setup

Please configure the following settings according to your application.

```ruby
Rails.application.configure do
  # NOTE: (OPTIONAL) id of the element (div) to mount (default: `app`)
  # config.kombu.default_mount_element_id = 'app'

  # NOTE: (REQUIIRED) Specify a proc that generates a tag that reads a javascript entry.
  # See `lib/kombu/renderable.rb` for instance variables provided by kombu that can be used within proc.
  config.kombu.javascript_entry_tag_proc = -> { helpers.javascript_pack_tag(@entry, defer: true) }

  # NOTE: (REQUIIRED) Specify a proc that generates a tag that reads a css entry.
  # See `lib/kombu/renderable.rb` for instance variables provided by kombu that can be used within proc.
  config.kombu.stylesheet_entry_tag_proc = -> { helpers.stylesheet_pack_tag(@entry) }

  # NOTE: (OPTIONAL) template of the view to render that contains the component. (default: See below)
  # config.kombu.default_entry_view_template = <<~ERB
  #   <div id="<%= @kombu_mount_element_id %>">
  #     <%= kombu_component_tag %>
  #   </div>
  #   <% content_for :stylesheet do %>
  #     <%= kombu_stylesheet_entry_tag %>
  #   <% end %>
  #   <% content_for :javascript do %>
  #     <%= kombu_javascript_entry_tag %>
  #   <% end %>
  # ERB
end
```

### Use `Kombu::Renderable`

If you include `Kombu::Renderable` in any controller, you can use `kombu_render_component` which can render component directly.

```ruby
class ArticlesController < ApplicationController
  include Kombu::Renderable

  def index
    title = 'Articles'
    articles = [{ id: 1, title: 'artile1', body: 'body1' }, { id: 2, title: 'artile2', body: 'body2' }]
    kombu_render_component('article-index-page', attributes: { 'title': title, ':articles': articles.to_json })
    # NOTE: The following html is rendered.
    # <div id="app"><artile-index-page title="Articles" :articles="[{"id":1,"title":"artile1","body":"body1"},{"id":2,"title":"artile2","body":"body2"}]"></artile-index-page></div>
  end
end
```

You can also use the input hidden as shown below to pass the initial data json without using component.(ex. React)

```ruby
class ArticlesController < ApplicationController
  include Kombu::Renderable

  def index
    title = 'Articles'
    articles = [{ id: 1, title: 'artile1', body: 'body1' }, { id: 2, title: 'artile2', body: 'body2' }]
    initial_value = { title: title, articles: articles }
    kombu_render_component('input', attributes: { 'type': 'hidden', 'id': 'initial-data', 'value': initial_value.to_json })
    # NOTE: The following html is rendered.
    # <div id="app"><input type="hidden" value='{"title":"Articles","articles":[{"id":1,"title":"artile1","body":"body1"},{"id":2,"title":"artile2","body":"body2"}]}' /></div>
  end
end
```

### (Optional) Rename method name.

If you do not like the method name, you can change it to any name you like.

```ruby
module ComponentRenderable
  extend ActiveSupport::Concern
  include Kombu::Renderable

  included do
    alias render_component kombu_render_component
  end
end
```

```ruby
class ArticlesController < ApplicationController
  include ComponentRenderable

  def index
    title = 'Articles'
    articles = [{ id: 1, title: 'artile1', body: 'body1' }, { id: 2, title: 'artile2', body: 'body2' }]
    render_component('article-index-page', attributes: { 'title': title, ':articles': articles.to_json })
  end
end
```

### Testing (RSpec only)

Kombu provides a matcher to validate values passed to `kombu_render_component`.
You can use `kombu_component_rendered` by enabling it in `RSpec.configure`.

```ruby
require 'kombu/test/rspec/matchers/component_renderd_matcher'

RSpec.configure do |config|
  config.include Kombu::RSpec::Matchers::ComponentRenderedMatcher, type: :request
end
```

```ruby
describe 'GET /articles', type: :request do
  before { get articles_path }

  it 'Specific arguments must be passed to render_component.' do
    title = 'Articles'
    articles = [{ id: 1, title: 'artile1', body: 'body1' }, { id: 2, title: 'artile2', body: 'body2' }]
    expect(controller).to kombu_component_rendered('article-index-page', attributes: { 'title': title, ':articles': articles.to_json })
  end
end
```

## How do it work

See `lib/kombu/renderable.rb`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "kombu"
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install kombu
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
