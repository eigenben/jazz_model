RSpec.describe JazzModel::KeyContext do
  describe "chord without context" do
    subject(:chord) { JazzModel::Chord["maj7"] }

    it "accepts key context" do
      expect(chord.in_key_of("G").key.name).to eq("G")
    end

    it "accepts then removes key context" do
      expect(chord.in_key_of("G").without_key.key).to be_nil
    end
  end

  describe "chord with context" do
    subject(:chord) { JazzModel::Chord["Fmaj7"] }

    it "has the correct context" do
      expect(chord.key.name).to eq("F")
    end

    it "can be put out of context" do
      expect(chord.without_key.key).to be_nil
    end
  end
end
