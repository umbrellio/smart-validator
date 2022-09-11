# frozen_string_literal: true

describe SmartValidator::Errors do
  subject(:errors) { described_class.new }

  specify { is_expected.not_to be_any }

  context "with safely added errors" do
    before { errors.safely_add!(attr_path: :some_field, error_code: :invalid) }

    it "provides indifferent access" do
      expect(errors[:some_field]).to eq(:invalid)
      expect(errors["some_field"]).to eq(:invalid)
    end
  end

  context "with multiple error codes safely added for same field" do
    before { errors.safely_add!(attr_path: :some_field, error_code: :invalid) }
    before { errors.safely_add!(attr_path: :some_field, error_code: :required) }

    it "saves only first error code" do
      expect(errors[:some_field]).to eq(:invalid)
    end
  end

  context "when converting errors to hash" do
    let(:errors_hash) { errors.to_h }
    let(:errors_container) { errors.instance_variable_get(:@errors_container) }

    it "returns a copy of errors container" do
      expect(errors_hash).to be_an_instance_of(Hash)
      expect(errors_hash.object_id).not_to eq(errors_container.object_id)
    end
  end

  context "when safely merging" do
    before { errors.safely_merge!(attr_path: :some_field, errors_enum: [:invalid]) }
    before { errors.safely_merge!(attr_path: :some_field, errors_enum: [:required]) }

    it "saves all error codes" do
      expect(errors[:some_field]).to be_an_instance_of(Set)
      expect(errors[:some_field]).to include(:invalid, :required)
    end
  end
end
