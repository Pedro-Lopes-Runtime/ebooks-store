RSpec.shared_context "authenticated user", :authenticated do
  let(:current_user) { create(:user) }

  before do
    stub_authentication_for(current_user)
  end
end

RSpec.shared_context "authenticated seller", :authenticated_seller do
  let(:current_user) { create(:user, :seller) }
  let!(:seller_ebooks) { create_list(:ebook, 3, user: current_user) }

  before do
    stub_authentication_for(current_user)
  end
end

RSpec.shared_context "authenticated ebook owner", :authenticated_ebook_owner do
  let(:ebook) { create(:ebook, :published) }

  before do
    stub_authentication_for(ebook.user)
  end
end
