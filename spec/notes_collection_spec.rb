RSpec.describe JazzModel::NotesCollection do
  it "skips invalid keys" do
    expect(described_class["C,E,G,H"].keys.size).to eq(3)
  end

  it "accepts key context" do
    expect(described_class["C,E,G,A"].in_key_of("A").chords.size).to eq(1)
  end

  {
    "A C E G" => %w[Amin7 C6]
  }.each do |notes, chords|
    it "finds #{chords.join(" and ")} for #{notes}" do
      notes_collection = described_class[notes]
      expect(notes_collection.chords.symbols).to match_array(chords)
    end
  end
end
