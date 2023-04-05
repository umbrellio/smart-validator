# frozen_string_literal: true

describe SmartValidator::Contract do
  subject(:result) { contract.call(checking_data, **external_deps) }

  let(:contract) do
    Class.new(described_class) do
      schema do
        required(:customer) do
          required(:first_name).type(:string).filled
          required(:last_name).type(:string).filled
        end
      end

      rule("customer.first_name") do
        failure(:too_short) if value.length <= 4
      end

      rule("customer.first_name") do
        failure(:kek_not_allowed) if value == "kek"
      end
    end
  end

  let(:checking_data) do
    { customer: { first_name: customer_first_name, last_name: customer_last_name } }
  end
  let(:external_deps) { Hash[] }
  let(:customer_first_name) { "Naruto" }
  let(:customer_last_name) { "Uzumaki" }

  specify { is_expected.to be_success }

  context "with wrong type" do
    let(:customer_first_name) { 42 }

    it "fails validation" do
      expect(result).to be_failed
      expect(result.errors.to_h).to include("customer.first_name" => :invalid_type)
    end
  end

  context "with failed rules" do
    let(:customer_first_name) { "kek" }

    it "fails validation with first error code" do
      expect(result).to be_failed
      expect(result.errors.to_h).to include("customer.first_name" => :too_short)
    end
  end

  context "with many error codes setting" do
    let(:contract) do
      Class.new(described_class) do
        configure do |config|
          config.errors_managing_type = :many_errors_per_attribute
        end

        schema do
          required(:customer) do
            required(:first_name).type(:string).filled
            required(:last_name).type(:string).filled
          end
        end

        rule("customer.first_name") do
          failure(:too_short) if value.length <= 4
        end

        rule("customer.first_name") do
          failure(:kek_not_allowed) if value == "kek"
        end
      end
    end

    let(:customer_first_name) { "kek" }

    it "saves all error codes" do
      expect(result).to be_failed
      expect(result.errors.to_h).to eq(
        "customer.first_name" => %i[too_short kek_not_allowed].to_set,
      )
    end
  end

  context "with same rule for each field" do
    let(:contract) do
      Class.new(described_class) do
        schema do
          required(:customer) do
            required(:first_name).type(:string).filled
            required(:last_name).type(:string).filled
          end
        end

        rule_for_each("customer.first_name", "customer.last_name") do
          failure(:too_short) if value.length <= 20
        end
      end
    end

    it "validates each field with this rule" do
      expect(result).to be_failed
      expect(result.errors.to_h).to eq(
        "customer.first_name" => :too_short,
        "customer.last_name" => :too_short,
      )
    end
  end

  context "with external dependencies" do
    let(:contract) do
      Class.new(described_class) do
        option :allowed_first_names
        option :allowed_last_names

        schema do
          required(:customer) do
            required(:first_name).type(:string).filled
            required(:last_name).type(:string).filled
          end
        end

        rule("customer.first_name") do
          failure(:not_allowed) unless allowed_first_names.include?(value)
        end
        rule("customer.last_name") do
          failure(:not_allowed) unless allowed_last_names.include?(value)
        end
      end
    end

    let(:external_deps) { Hash[allowed_first_names: ["Cheng"], allowed_last_names: ["Uzumaki"]] }

    it "binds deps to rule validation context" do
      expect(result).to be_failed
      expect(result.errors.to_h).to eq(
        "customer.first_name" => :not_allowed,
      )
    end
  end

  context "when define deps in params" do
    def define_invalid_contract
      Class.new(described_class) { param :some_dep }
    end

    let(:error_message) { "params are not permitted to use in validators" }

    it "raises an error" do
      expect { define_invalid_contract }.to raise_error(NotImplementedError, error_message)
    end
  end

  context "when dependency name is overlaping base method" do
    let(:contract) do
      Class.new(described_class) { option :private_methods }
    end
    let(:external_deps) { Hash[private_methods: "kek"] }

    let(:error_message) do
      "dependency name conflicts with standard method: private_methods"
    end

    it "raises an error" do
      expect { result }.to raise_error(ArgumentError, error_message)
    end
  end

  context "when set invalid config" do
    def define_invalid_contract
      Class.new(described_class) do
        configure { |c| c.errors_managing_type = 123 }
      end
    end

    it "raises with config validation error" do
      expect { define_invalid_contract }.to raise_error(Qonfig::ValidationError)
    end
  end

  context "when non strict schema" do
    let(:contract) do
      Class.new(described_class) do
        schema do
          non_strict!

          optional(:age).type(:integer).filled
          optional(:customer) do
            required(:first_name).type(:string).filled
          end
        end

        rule("customer.first_name") do
          failure(:too_short) if value.length <= 4
        end

        rule("gender") do
          failure(:under_age) if value < 18
        end
      end
    end
    let(:checking_data) do
      { other_field: "value" }
    end

    specify { is_expected.to be_success }
  end

  context "when attr is optional" do
    let(:contract) do
      Class.new(described_class) do
        schema do
          optional(:age).type(:integer).filled
        end

        rule("gender") do
          failure(:under_age) if value < 18
        end
      end
    end
    let(:checking_data) do
      {}
    end

    specify { is_expected.to be_success }
  end
end
