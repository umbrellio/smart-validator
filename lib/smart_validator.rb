# frozen_string_literal: true

require "forwardable"
require "smart_core/schema"
require "smart_core/initializer"
require "qonfig"

module SmartValidator
  ERROR_CODE_HANDLING_TYPES = %i[one many].freeze
end

require_relative "smart_validator/version"
require_relative "smart_validator/utils"
require_relative "smart_validator/errors_controller"
require_relative "smart_validator/errors"
require_relative "smart_validator/class_state"
require_relative "smart_validator/rule"
require_relative "smart_validator/rule_execution_context"
require_relative "smart_validator/result"
require_relative "smart_validator/contract"
