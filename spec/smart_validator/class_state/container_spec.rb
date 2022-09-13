# frozen_string_literal: true

describe SmartValidator::ClassState::Container do
  subject(:container) { described_class.create_base_container }

  it "freezes state after creation" do
    expect(container).to be_frozen
    expect(container.configuration).to be_frozen
    expect(container.rules).not_to be_frozen
  end

  context "when duplicate container" do
    let(:container_dup) { container.dup }

    it "properly does deep duplication" do
      expect(container_dup).to be_frozen
      expect(container_dup.configuration).not_to be_frozen
      expect(container_dup.configuration.object_id).not_to eq(container.configuration.object_id)
      expect(container_dup.rules.object_id).not_to eq(container.rules.object_id)
      expect(container_dup.schema_class.object_id).not_to eq(container.schema_class.object_id)
    end
  end
end
