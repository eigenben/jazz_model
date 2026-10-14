RSpec.describe JazzModel::Chord do
  it "is valid when new" do
    expect(described_class.new).to be_valid
  end

  {
    "Cmaj" => %w[C E G],
    "Cmin" => %w[C Eb G],
    "Cmaj7" => %w[C E G B],
    "Cmin7" => %w[C Eb G Bb],
    "C7" => %w[C E G Bb],
    "Cfulldim" => %w[C Eb Gb Bbb]
  }.each do |chord_symbol, notes|
    it "spells #{chord_symbol} as #{notes.join(" ")}" do
      chord = described_class[chord_symbol]
      expect(chord).not_to be_nil
      expect(chord.notes).to eq(notes)
    end
  end
end
