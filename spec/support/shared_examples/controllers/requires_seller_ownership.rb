RSpec.shared_examples "requires seller ownership" do
  it "returns sucess if it's the seller's own book" do
    expect(response).to be_successful
  end

  it "redirect to root if it's not the seller's own book" do
    expect(response).to redirect_to(root_path)
  end
end
