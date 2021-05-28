# frozen_string_literal: true

module SmartValidator
  module Utils
    extend self

    def deeply_symbolize(hash)
      hash.transform_keys(&:to_sym).transform_values do |value|
        next value unless value.is_a?(Hash)

        deeply_symbolize(value)
      end
    end
  end
end
