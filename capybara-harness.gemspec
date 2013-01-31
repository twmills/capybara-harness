# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara/harness/version'

Gem::Specification.new do |gem|
  gem.name          = "capybara-harness"
  gem.version       = Capybara::Harness::VERSION
  gem.authors       = ["Theo Mills"]
  gem.email         = ["twmills@twmills.com"]
  gem.description   = "A test harness strategy to easily query and manipulate DOM elements as self-contained objects in the context of feature or acceptance tests."
  gem.summary       = "A test harness strategy to easily query and manipulate DOM elements as self-contained objects in the context of feature or acceptance tests."
  gem.homepage      = "https://github.com/twmills/capybara-harness"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('launchy')
  gem.add_runtime_dependency('capybara', '>= 1.1')
  gem.add_development_dependency("sinatra", [">= 0.9.4"])
  gem.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
end
