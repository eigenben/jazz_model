RSpec.describe JazzModel::ToneSequence do
  subject(:chord) { JazzModel::Chord["Cmaj7"] }

  it "accepts key context" do
    expect(chord.tones.in_key_of("F").notes.first).to eq("F")
  end

  it "orders tones by position" do
    expect(chord.tones.in_context.map(&:position)).to eq([1, 2, 3, 4])
  end

  it "accepts mode context" do
    expect(chord.tones.in_mode(2).notes.first).to eq("E")
  end
end
