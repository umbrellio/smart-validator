# frozen_string_literal: true

module SmartValidator
  class RuleExecutionContext < Object
    class Failure < ::StandardError
      attr_reader :code

      def initialize(code)
        @code = code
        super(code)
      end
    end

    def initialize(value, data)
      @value = value
      @data = data
    end

    private

    attr_reader :value, :data

    def failure(code)
      Kernel.raise Failure, code
    end
  end
end
