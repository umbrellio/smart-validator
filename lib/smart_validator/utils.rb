# frozen_string_literal: true

module SmartValidator
  module Utils
    extend self

    def deeply_symbolize_freeze(hash)
      hash.freeze.transform_keys(&:to_sym).transform_values do |value|
        next value.freeze unless value.is_a?(Hash)

        deeply_symbolize_freeze(value)
      end
    end
  end
end
