RSpec.describe JazzModel::Key do
  it "defaults to C" do
    expect(described_class.default.name).to eq("C")
  end

  it "exposes 12 primary keys" do
    expect(described_class.primaries.size).to eq(12)
  end

  it "treats Eb and D# as enharmonic" do
    expect(described_class["Eb"]).to be_enharmonic_with(described_class["D#"])
  end
end
