RSpec.shared_examples "a model with timestamps" do
  it "has timestamps" do
    expect(subject).to respond_to(:created_at)
    expect(subject).to respond_to(:updated_at)
  end

  it "has a default status" do
    expect(subject.status).to be_present
  end
end
