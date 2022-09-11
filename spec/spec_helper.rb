# frozen_string_literal: true

require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.single_report_path = "coverage/lcov.info"
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter,
])

SimpleCov.enable_coverage(:branch)
SimpleCov.enable_coverage(:line)
SimpleCov.primary_coverage(:branch)
SimpleCov.minimum_coverage(line: 100, branch: 100) if ENV["FULL_COVERAGE_CHECK"] == "true"
SimpleCov.add_filter("spec")
SimpleCov.start

require "bundler/setup"
require "pry"
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
