RSpec.shared_examples "requires authentication" do
  it "redirects to login when not authenticated" do
    expect(response).to redirect_to(sign_in_path)
  end
end
