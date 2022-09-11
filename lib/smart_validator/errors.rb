# frozen_string_literal: true

module SmartValidator
  class Errors
    extend Forwardable
    include Enumerable

    def_delegators :@errors_container, :each, :as_json, :to_json

    def initialize
      self.errors_container = {}
    end

    def safely_add!(attr_path:, error_code:)
      errors_container[attr_path.to_s] ||= error_code
    end

    def safely_merge!(attr_path:, errors_enum:)
      errors_container[attr_path.to_s] ||= Set.new
      errors_container[attr_path.to_s].merge(errors_enum)
    end

    def [](attr_path)
      errors_container[attr_path.to_s]
    end

    def freeze
      super.tap { errors_container.transform_values(&:freeze) }
    end

    def to_h
      errors_container.dup
    end

    def attribute_already_exists?(attr_path)
      errors_container.key?(attr_path.to_s)
    end

    private

    attr_accessor :errors_container
  end
end
