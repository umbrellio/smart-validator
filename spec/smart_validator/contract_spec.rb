# frozen_string_literal: true

describe SmartValidator::Contract do
  subject(:result) { contract.call(checking_data) }

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
        handle_error_codes :many

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
end
