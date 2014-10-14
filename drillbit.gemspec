$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "drillbit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "drillbit"
  s.version     = Drillbit::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Drillbit."
  s.description = "TODO: Description of Drillbit."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
