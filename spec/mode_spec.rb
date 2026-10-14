RSpec.describe JazzModel::Mode do
  subject(:mode) { JazzModel::Scale["CMajor"].modes["Dorian"] }

  it "yields the correct notes" do
    expect(mode.notes).to eq(%w[D E F G A B C])
  end
end

RSpec.describe JazzModel::Mode, "numbering" do
  {
    ["Major", 6] => "Aeolian",
    ["Major", 7] => "Locrian",
    ["Melodic Minor", 6] => "Locrian #2",
    ["Melodic Minor", 7] => "Super Locrian"
  }.each do |(scale, number), name|
    it "finds #{scale} mode #{number} as #{name}" do
      expect(JazzModel::Scale[scale][number].name).to eq(name)
    end
  end

  it "spells Super Locrian from the seventh degree" do
    expect(JazzModel::Scale["Melodic Minor"]["Super Locrian"].notes).to eq(%w[B C D Eb F G A])
  end
end

RSpec.describe JazzModel::Mode, "chords" do
  it "relates Dorian to minor chords" do
    expect(JazzModel::Scale["Major"]["Dorian"].chords.symbols).to contain_exactly("min", "min7", "min6")
  end

  it "does not relate Ionian to minor chords" do
    expect(JazzModel::Scale["Major"]["Ionian"].chords.symbols).not_to include("min6")
  end
end
