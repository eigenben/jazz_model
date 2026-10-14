require "jazz_model"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = ".rspec_status"
  config.order = :random
  Kernel.srand config.seed
end

# TODO: Move to context in individual specs, or test in a separate namespace
JazzModel::Base.load_definitions
