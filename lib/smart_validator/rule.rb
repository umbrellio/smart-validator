# frozen_string_literal: true

module SmartValidator
  class Rule
    attr_reader :checked_attr

    def initialize(checked_attr, checking_block)
      @checked_attr = checked_attr.to_s
      @attr_path = @checked_attr.split(".").map(&:to_sym)
      @checking_block = checking_block
    end

    def run_for(data)
      value = data.dig(*@attr_path)
      RuleExecutionContext.new(value, data).instance_eval(&@checking_block)
      nil
    rescue RuleExecutionContext::Failure => e
      e.code
    end
  end
end
