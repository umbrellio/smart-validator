# frozen_string_literal: true

describe SmartValidator::Result do
  subject(:result) do
    described_class.new(
      errors: SmartValidator::Errors.new,
      data: data,
      failed: false,
    )
  end

  let(:data) { Hash[kek: :cheburek] }

  specify { is_expected.to be_success }

  it "delegates #to_h to the data" do
    expect(result.to_h).to eq(kek: :cheburek)
  end

  context "when freeze is performed" do
    it "properly freezes state also for linked objects" do
      expect(result.freeze).to eq(result)
      expect(result).to be_frozen
      expect(result.errors).to be_frozen
      expect(result.data).to be_frozen
    end
  end

  context "when builds instance from state" do
    subject(:result) do
      described_class.build_from_state({}, state_manager)
    end

    let(:state_manager) do
      instance_double(SmartValidator::ErrorsController::Base).tap do |instance|
        allow(instance).to receive(:freeze)
        allow(instance).to receive(:errors)
        allow(instance).to receive(:validation_fails?)
      end
    end

    it "freezes created instance" do
      expect(result).to be_frozen
    end
  end
end
