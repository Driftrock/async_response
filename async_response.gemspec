$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "async_response/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "async_response"
  s.version     = AsyncResponse::VERSION
  s.authors     = ["Driftrock"]
  s.email       = ["dev@driftrock.com"]
  s.homepage    = "http://www.driftrock.com"
  s.summary     = "Handle async call using Sidekiq."
  s.description = "Handle async call using Sidekiq."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "sidekiq"
  s.add_dependency "haml-rails"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "pry"
end
