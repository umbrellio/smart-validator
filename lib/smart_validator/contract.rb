# frozen_string_literal: true

module SmartValidator
  class Contract
    DEFAULT_NUMBER_OF_ERROR_CODES = :one

    # TODO: Move this logic to the module
    class << self
      attr_reader :rules, :error_codes

      def inherited(subclass)
        super
        subclass.const_set(:SchemaContainer, Class.new(SmartCore::Schema))
        # NOTE: SmartCore::Schema doesn't provide schema inheritance.
        subclass.instance_variable_set(:@rules, [])
        subclass.instance_variable_set(:@error_codes, DEFAULT_NUMBER_OF_ERROR_CODES)
      end

      def call(*args, **kwargs)
        new.call(*args, **kwargs)
      end

      def schema(&block)
        self::SchemaContainer.schema(&block)
      end

      def rule(checked_value, &block)
        @rules << Rule.new(checked_value, block)
      end

      def rule_for_each(*checked_values, &block)
        checked_values.each { |checked_value| rule(checked_value, &block) }
      end

      def handle_error_codes(handling_type)
        @error_codes = handling_type
      end
    end

    def initialize
      self.schema = self.class::SchemaContainer.new
    end

    def call(validated_data)
      self.data = Utils.deeply_symbolize(validated_data)
      result = schema.validate(data)
      return build_result(result.errors) unless result.success?

      check_with_rules
    end

    private

    attr_accessor :schema, :data

    def build_result(errors)
      wrapped_errors = Errors.wrap_hash(wrapping_hash: errors, handling_type: error_codes)
      Result.new(errors: wrapped_errors, data: data)
    end

    def check_with_rules
      safe_data = data.dup.freeze
      errors = rules.each_with_object(Errors.new(error_codes)) do |rule, errors|
        next if errors.skip_validation_check_for?(rule.checked_attr)

        error_code = rule.run_for(safe_data)
        errors.add!(rule.checked_attr, error_code) unless error_code.nil?
      end

      Result.new(errors: errors, data: data)
    end

    def rules
      self.class.rules
    end

    def error_codes
      self.class.error_codes
    end
  end
end
