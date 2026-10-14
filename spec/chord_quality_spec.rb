RSpec.describe JazzModel::ChordQuality do
  it "is valid when new" do
    expect(described_class.new).to be_valid
  end

  %w[Major Minor Dominant Diminished].each do |name|
    it "defines the #{name} quality" do
      expect(described_class[name]).to be_valid
    end
  end
end
