RSpec.describe JazzModel::Mode do
  subject(:mode) { JazzModel::Scale["CMajor"].modes["Dorian"] }

  it "yields the correct notes" do
    expect(mode.notes).to eq(%w[D E F G A B C])
  end
end
