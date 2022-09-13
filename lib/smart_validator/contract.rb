# frozen_string_literal: true

module SmartValidator
  class Contract
    include SmartCore::Initializer
    include ClassState::InitializeMixin

    class << self
      def inherited(subclass)
        super
        subclass.__state_container__ = __state_container__.dup
      end

      def param(*)
        raise NotImplementedError, "params are not permitted to use in validators"
      end

      # NOTE: In Ruby 2.6.x need to initialize instance without arguments if they not expected.
      def call(data_to_validate, **kwargs)
        instance = kwargs.empty? ? new : new(**kwargs)
        instance.call(data_to_validate)
      end

      def schema(&block)
        schema_class.schema(&block)
      end

      # TODO: Delegate all this logic to the Rules.
      def rule(checked_value, &block)
        rules << Rule.new(checked_value, block)
      end

      def rule_for_each(*checked_values, &block)
        checked_values.each { |checked_value| rule(checked_value, &block) }
      end
    end

    def call(data_to_validate)
      self.data = Utils.deeply_symbolize_freeze(data_to_validate)
      self.errors_controller = ErrorsController.resolve_from(settings.errors_managing_type)
      self.rule_execution_context = build_rule_execution_context

      result = build_schema_instance.validate(data)
      errors_controller.process_smart_schema_result!(result)
      return build_result if errors_controller.validation_fails?

      check_with_rules!
      build_result
    end

    private

    attr_accessor :data, :errors_controller, :rule_execution_context

    def build_rule_execution_context
      RuleExecutionContext.new(data, __options__)
    end

    def build_schema_instance
      schema_class.new
    end

    def build_result
      Result.build_from_state(data, errors_controller)
    end

    def check_with_rules!
      rules.each do |rule|
        next if errors_controller.error_will_be_skipped?(rule.checked_attr)

        result = rule_execution_context.execute!(rule)
        errors_controller.process_rule!(result)
      end
    end
  end
end
