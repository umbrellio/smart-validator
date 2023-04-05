# frozen_string_literal: true

require_relative "lib/smart_validator/version"

Gem::Specification.new do |spec|
  spec.name          = "smart-validator"
  spec.version       = SmartValidator::VERSION
  spec.authors       = ["JustAnotherDude"]
  spec.email         = ["vanyaz158@gmail.com"]

  spec.summary       = "Short decription"
  spec.description   = "PoC of validation gem."
  spec.homepage      = "https://github.com/umbrellio/smart-validator"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/umbrellio/smart-validator"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "qonfig"
  spec.add_dependency "smart_initializer"
  spec.add_dependency "smart_schema"

  spec.add_development_dependency "bundler-audit"
  spec.add_development_dependency "ci-helper"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop-config-umbrellio"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-lcov"
end
