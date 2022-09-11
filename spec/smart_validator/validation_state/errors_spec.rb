# frozen_string_literal: true

describe SmartValidator::ValidationState::Errors do
  subject(:errors) { described_class.new(handling_type) }

  let(:handling_type) { :one }

  specify { is_expected.not_to be_any }

  context "with added errors" do
    before { errors.add!(:some_field, :invalid) }

    it "provides indifferent access" do
      expect(errors[:some_field]).to eq(:invalid)
      expect(errors["some_field"]).to eq(:invalid)
    end

    it "properly responses to invalid_attribute?" do
      expect(errors.invalid_attribute?(:some_field)).to be_truthy
      expect(errors.invalid_attribute?(:other_field)).to be_falsey
    end
  end

  context "with multiple error codes for same field" do
    before { errors.add!(:some_field, :invalid) }
    before { errors.add!(:some_field, :required) }

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

  context "with :many handling type" do
    before { errors.add!(:some_field, :invalid) }
    before { errors.add!(:some_field, :required) }

    let(:handling_type) { :many }

    it "saves all error codes" do
      expect(errors[:some_field]).to be_an_instance_of(Set)
      expect(errors[:some_field]).to include(:invalid, :required)
    end
  end

  context "with invalid handling type" do
    it "raises ArgumentError" do
      expect { described_class.new(:invalid_type) }.to raise_error(ArgumentError)
    end
  end
end
