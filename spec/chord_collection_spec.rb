RSpec.describe JazzModel::ChordCollection do
  subject(:chords) { JazzModel::Scale["Major"].modes[1].chords }

  it "emits a symbols list" do
    expect(chords.to_s(:symbols)).to start_with("maj")
  end

  it "emits a names list" do
    expect(chords.to_s(:names)).to start_with("Major")
  end

  it "resolves a chord within" do
    expect(chords["maj"]).not_to be_nil
  end

  it "resolves a chord within with key context" do
    expect(chords["Cmaj"]).not_to be_nil
  end
end
