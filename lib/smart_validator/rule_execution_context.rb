# frozen_string_literal: true

module SmartValidator
  class RuleExecutionContext
    class Failure < StandardError
      attr_reader :code

      def initialize(code)
        @code = code
        super(code)
      end
    end

    Result = Struct.new(:attr_path, :code)

    def initialize(data, dependencies_to_bind)
      self.data = data
      bind_to_self!(dependencies_to_bind)
    end

    def execute!(rule)
      self.value = rule.value_from(data)
      instance_eval(&rule)
      nil
    rescue Failure => e
      Result.new(rule.checked_attr, e.code).freeze
    end

    private

    attr_accessor :data, :value

    def bind_to_self!(dependencies)
      dependencies.each do |name, value|
        if singleton_class.method_defined?(name)
          raise ArgumentError, "dependency name conflicts with standard method: #{name}"
        end

        define_singleton_method(name) { value }
      end
    end

    def failure(code)
      raise Failure, code
    end
  end
end
