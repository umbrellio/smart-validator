# frozen_string_literal: true

module SmartValidator
  module ClassState
    class Container
      attr_accessor :schema_class, :configuration, :rules

      class << self
        def new(*args)
          super.freeze
        end

        def create_base_container
          new(build_base_config)
        end

        private

        # TODO: Use global config until #configure is called on the class.
        def build_base_config
          config = Qonfig::DataSet.build do
            setting :errors_managing_type, :error_per_attribute
            setting :smart_initializer do
              # TODO: After calling configure method,
              # also apply changes to the #__settings__ of the Contract class.
              compose SmartCore::Initializer::Configuration.config.class
            end

            validate :errors_managing_type do |value|
              SmartValidator::ErrorsController::ALLOWED_MANAGING_TYPES.key?(value)
            end
          end

          config.tap(&:freeze!)
        end
      end

      def initialize(duplicated_configuration)
        self.schema_class = Class.new(SmartCore::Schema)
        self.configuration = duplicated_configuration
        self.rules = []
      end

      private

      def initialize_copy(parent_container)
        super
        self.schema_class = Class.new(SmartCore::Schema)
        self.rules = []
        self.configuration = parent_container.configuration.dup
        freeze
      end
    end
  end
end
