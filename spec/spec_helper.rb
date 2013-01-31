require "capybara"
require "capybara/rspec" # Required here instead of in rspec_spec to avoid RSpec deprecation warning
require "capybara/spec/test_app"
require "capybara/spec/spec_helper"
require 'capybara-harness'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.before { Capybara::SpecHelper.reset! }
  config.after { Capybara::SpecHelper.reset! }
end