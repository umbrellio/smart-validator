# frozen_string_literal: true

module SmartValidator
  module ClassState
    module InitializeMixin
      def self.included(mod)
        super

        mod.singleton_class.attr_accessor :__state_container__
        mod.singleton_class.send(:protected, :__state_container__=)
        mod.instance_variable_set(:@__state_container__, Container.create_base_container)
        add_delegators_to(mod)
      end

      def self.add_delegators_to(mod)
        mod.instance_eval do
          extend Forwardable
          extend SingleForwardable

          def_single_delegators :__state_container__, :schema_class, :configuration, :rules
          def_single_delegators :configuration, :configure, :settings
          def_instance_delegators "self.class", :settings, :rules, :schema_class
        end
      end
    end
  end
end
