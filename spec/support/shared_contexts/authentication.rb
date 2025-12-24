RSpec.shared_context "authenticated user" do
  let(:current_user) { create(:user, :buyer) }

  before do
    stub_authentication_for(current_user)
  end
end

RSpec.shared_context "authenticated seller" do
  let(:current_user) { create(:user, :seller) }

  before do
    stub_authentication_for(current_user)
  end
end

RSpec.shared_context "authenticated seller with ebooks" do
  let(:current_user) { create(:user, :seller) }
  let!(:seller_ebooks) { create_list(:ebook, 3, user: current_user) }

  before do
    stub_authentication_for(current_user)
  end
end

RSpec.shared_context "authenticated ebook owner" do
  let(:ebook) { create(:ebook, :published) }

  before do
    stub_authentication_for(ebook.user)
  end
end
