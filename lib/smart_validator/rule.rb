# frozen_string_literal: true

module SmartValidator
  class Rule
    attr_reader :checked_attr

    def initialize(checked_attr, checking_block)
      @checked_attr = checked_attr.to_s
      @attr_path = @checked_attr.split(".").map(&:to_sym)
      @checking_block = checking_block
    end

    def value_from(data)
      data.dig(*@attr_path)
    end

    def to_proc
      @checking_block
    end
  end
end
