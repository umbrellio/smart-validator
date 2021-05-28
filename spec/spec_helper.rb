# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
# require "simplecov-lcov"

# SimpleCov::Formatter::LcovFormatter.config do |c|
#   c.report_with_single_file = true
#   c.lcov_file_name = "lcov.info"
#   c.output_directory = "coverage"
# end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  # SimpleCov::Formatter::LcovFormatter,
])

SimpleCov.enable_coverage(:line)
SimpleCov.enable_coverage(:branch)
SimpleCov.minimum_coverage(line: 100, branch: 100)
SimpleCov.add_filter "spec"
SimpleCov.start

require "smart_validator"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.expose_dsl_globally = true
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
