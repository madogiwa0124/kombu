require_relative "lib/kombu/version"

Gem::Specification.new do |spec|
  spec.name = "kombu"
  spec.version = Kombu::VERSION
  spec.authors = ["madogiwa"]
  spec.homepage = "https://github.com/madogiwa0124/kombu"
  spec.summary = "Kombu provides the ability to render the specified component directly from the controller."
  spec.license = "MIT"
  spec.email = ["madogiwa0124@gmail.com"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0"
end
