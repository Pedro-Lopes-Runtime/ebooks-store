RSpec.shared_context "with published ebooks" do
  let(:seller) { create(:user, :seller) }
  let!(:published_ebooks) { create_list(:ebook, 5, :published, user: seller) }
  let!(:draft_ebooks) { create_list(:ebook, 2, :draft, user: seller) }
end

RSpec.shared_context "with purchase setup" do
  let(:seller) { create(:user, :seller) }
  let(:buyer) { create(:user, :buyer, balance: 100) }
  let(:ebook) { create(:ebook, :published, user: seller, price: 29.99) }

  before do
    stub_authentication_for(buyer)
  end
end

RSpec.shared_context "with ebook" do
  let(:ebook) { create(:ebook) }
end
