RSpec.shared_examples "a model with status" do
  it "has a status attribute" do
    expect(subject).to respond_to(:status)
  end

  it "has a default status" do
    expect(subject.status).to be_present
  end
end
