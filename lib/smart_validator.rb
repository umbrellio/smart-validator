# frozen_string_literal: true

require "forwardable"
require "smart_core/schema"

module SmartValidator
  require_relative "smart_validator/version"
  require_relative "smart_validator/utils"
  require_relative "smart_validator/rule"
  require_relative "smart_validator/errors"
  require_relative "smart_validator/result"
  require_relative "smart_validator/rule_execution_context"
  require_relative "smart_validator/contract"
end
