RSpec.describe JazzModel::ChordTone do
  it "is valid when new" do
    expect(described_class.new).to be_valid
  end
end
