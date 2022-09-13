# frozen_string_literal: true

describe SmartValidator::ErrorsController do
  subject(:resolve_result) { described_class.resolve_from(managing_type) }

  let(:managing_type) { :error_per_attribute }

  it "properly resolves class" do
    expect(resolve_result).to be_an_instance_of(described_class::ErrorPerAttribute)
  end

  context "with invalid managing type" do
    let(:managing_type) { :invalid }

    it "raises error" do
      expect { resolve_result }.to raise_error(ArgumentError, /invalid handling type/)
    end
  end
end
