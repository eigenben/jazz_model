RSpec.describe JazzModel::Scale do
  subject(:scale) { described_class["Major"] }

  it { is_expected.to be_valid }

  it "recognizes a symmetric scale" do
    expect(described_class["Diminished"]).to be_symmetric
  end

  it "recognizes an asymmetric scale" do
    expect(scale).not_to be_symmetric
  end

  it "accepts numeric mode context" do
    expect(scale.in_mode(2).notes.first).to eq("D")
  end

  it "accepts named mode context" do
    expect(scale.in_mode("Dorian").notes.first).to eq("D")
  end

  it "removes mode context" do
    expect(scale.in_mode("Dorian").without_mode.notes.first).to eq("C")
  end

  {
    "C Major" => %w[C D E F G A B],
    "C Harmonic Minor" => %w[C D Eb F G Ab B]
  }.each do |name, notes|
    it "spells #{name} as #{notes.join(" ")}" do
      scale = described_class[name]
      expect(scale).not_to be_nil
      expect(scale.notes).to eq(notes)
    end
  end
end
