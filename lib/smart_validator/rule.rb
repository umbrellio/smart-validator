# frozen_string_literal: true

module SmartValidator
  class Rule
    attr_reader :checked_attr

    def initialize(checked_attr, checking_block)
      @checked_attr = checked_attr.to_s
      @attr_path = @checked_attr.split(".").map(&:to_sym)
      @checking_block = checking_block
    end

    def executable?(data)
      checked_path, checked_key = @attr_path[..-2], @attr_path.last
      data = data.dig(*checked_path) if checked_path.any?
      data&.key?(checked_key)
    end

    def value_from(data)
      data.dig(*@attr_path)
    end

    def to_proc
      @checking_block
    end
  end
end
