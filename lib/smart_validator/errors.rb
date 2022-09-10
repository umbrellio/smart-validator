# frozen_string_literal: true

module SmartValidator
  class Errors
    extend Forwardable
    include Enumerable

    VALID_HANDLING_TYPES = %i[one many].freeze

    def_delegators :@errors_container, :each, :empty?, :as_json, :to_json

    def self.wrap_hash(wrapping_hash:, handling_type:)
      new(handling_type).tap do |errors|
        wrapping_hash.each do |attr_path, err_codes|
          Array(err_codes).each { |code| errors.add!(attr_path, code) }
        end
      end
    end

    def initialize(handling_type)
      self.handling_type = handling_type
      self.errors_container = {}
      validate_handling_type!
    end

    def add!(attr_path, error_code)
      path = attr_path.to_s

      if handling_type == :one
        errors_container[path] ||= error_code
      else
        errors = errors_container[path] ||= Set.new
        errors << error_code
      end
    end

    def [](attr_path)
      errors_container[attr_path.to_s]
    end

    def to_h
      errors_container.dup
    end

    def skip_validation_check_for?(attr_path)
      return false if handling_type == :many

      @errors_container.key?(attr_path.to_s)
    end

    private

    attr_accessor :handling_type, :errors_container

    def validate_handling_type!
      return if VALID_HANDLING_TYPES.include?(handling_type)

      raise ArgumentError, "invalid handling type: #{handling_type.inspect}"
    end
  end
end
