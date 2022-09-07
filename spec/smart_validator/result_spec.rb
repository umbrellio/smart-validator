# frozen_string_literal: true

describe SmartValidator::Result do
  subject(:result) { described_class.new(errors: SmartValidator::Errors.new(:one), data: data) }

  let(:data) { Hash[kek: :cheburek] }

  it "delegates #to_h to the data" do
    expect(result.to_h).to eq(kek: :cheburek)
  end
end
