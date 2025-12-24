require 'rails_helper'


RSpec.describe Ebook, type: :model do
  context do
    subject { create(:ebook) }
    it_behaves_like "a model with status"
  end

  context "draft" do
    subject { create(:ebook, :draft) }
    it_behaves_like "a publishable resource"
  end

  context "Instantiate Ebook" do
    it "is valid with valid attributes" do
      expect(build_stubbed(:ebook)).to be_valid
    end

    it_behaves_like "validates presence of", :title
    it_behaves_like "validates presence of", :description
    it_behaves_like "validates presence of", :price
  end

  context "Test enum attributes" do
    it_behaves_like "validates enum", :status, %w[draft pending live]

    it "should have valid status" do
      ebook = build_stubbed(:ebook)
      expect(ebook).to be_valid
      ebook.status = "pending"
      expect(ebook).to be_valid
      ebook.status = "live"
      expect(ebook).to be_valid
      ebook.status = "non_valid"
      expect(ebook).to_not be_valid
    end
  end

  context "Test numericality validation" do
    it "should have price greater or equal to 0" do
      ebook = build_stubbed(:ebook)
      expect(ebook).to be_valid
      ebook.price = 0
      expect(ebook).to be_valid
      ebook.price = -10
      expect(ebook).to_not be_valid
    end
  end

  context "Test association" do
    it { should belong_to(:user) }
    it { should belong_to(:author) }
    it { should have_many(:purchases) }
  end

  context ".draft" do
    it_behaves_like "filters by status scope", :draft, :draft
  end

  context ".pending" do
    it_behaves_like "filters by status scope", :pending, :pending
  end

  context ".published" do
    it_behaves_like "filters by status scope", :published, :live
  end

  context ".by_seller" do
    it "returns only ebooks from the seller" do
      user_ebook = create(:ebook)
      seller2_ebook = create(:ebook)

      user_ebooks = Ebook.by_seller(user_ebook.user)
      expect(user_ebooks).to include(user_ebook)
      expect(user_ebooks).to_not include(seller2_ebook)
    end
  end

  context "published.by_seller" do
    it "returns only live ebooks from the seller" do
      user = build_stubbed(:user)
      user_draft_ebook = create(:ebook, :draft, user: user)
      user_pending_ebook = create(:ebook, :pending, user: user)
      user_published_ebook = create(:ebook, :published, user: user)
      other_seller_ebook = create(:ebook, :published)

      published_user_ebooks = Ebook.published.by_seller(user)
      expect(published_user_ebooks).to include(user_published_ebook)
      expect(published_user_ebooks).to_not include(user_pending_ebook)
      expect(published_user_ebooks).to_not include(user_draft_ebook)
      expect(published_user_ebooks).to_not include(other_seller_ebook)
    end
  end

  context "Test instance methods" do
    it ".publish! should change status from pending to live" do
      draft_ebook = build_stubbed(:ebook, :draft)
      pending_ebook = build_stubbed(:ebook, :pending)

      expect { draft_ebook.publish! }.to_not change { draft_ebook.status }
      expect { pending_ebook.publish! }.to change { pending_ebook.status }.to "live"
    end

    it ".submit_for_review! should change status from draft to pending" do
      draft_ebook = build_stubbed(:ebook, :draft)
      live_ebook = build_stubbed(:ebook, :live)

      expect { draft_ebook.submit_for_review! }.to change { draft_ebook.status }.to "pending"
      expect { live_ebook.submit_for_review! }.to_not change { live_ebook.status }
    end

    it ".view_count return ebook views" do
      ebook = create(:ebook)

      expect { ebook.ebook_statistic.visits += 1 }.to change { ebook.view_count }.by 1
    end

    it ".purchase_count return ebook purchases" do
      ebook = create(:ebook)

      expect { ebook.ebook_statistic.purchases += 1 }.to change { ebook.purchase_count }.by 1
    end
  end
end
