require "bundler/setup"
require "bottleneck"
require "bottleneck/core_helpers"
require "fakeredis"

RSpec.configure do |config|
  config.include CoreHelpers
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
