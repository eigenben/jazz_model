RSpec.describe JazzModel::Definition do
  context "after creating a definition" do
    before(:all) do
      described_class.define my_definition: [:keys] do
        JazzModel::Scale.create!(name: "Sample")
      end
    end

    let(:definition) { described_class[:my_definition] }

    it "registers my_definition" do
      expect(definition).not_to be_nil
    end

    it "lists keys as an included definition" do
      expect(definition.included_definitions).to include(:keys)
    end

    context "when loaded" do
      before { definition.load }

      it "creates keys" do
        expect(JazzModel::Key.find_by_name("C")).not_to be_nil
      end

      it "creates the sample scale" do
        expect(JazzModel::Scale.find_by_name("Sample")).not_to be_nil
      end
    end
  end
end
