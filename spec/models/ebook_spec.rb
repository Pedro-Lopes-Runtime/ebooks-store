require 'rails_helper'


RSpec.describe Ebook, type: :model do
  context "Instantiate Ebook" do
    it "is valid with valid attributes" do
      expect(build_stubbed(:ebook)).to be_valid
    end

    it "is invalid with no title" do
      ebook = build_stubbed(:ebook, title: nil)
      expect(ebook).to_not be_valid
      expect(ebook.errors.full_messages).to include "Title can't be blank"
    end

    it "is invalid with no description" do
      ebook = build_stubbed(:ebook, description: nil)
      expect(ebook).to_not be_valid
      expect(ebook.errors.full_messages).to include "Description can't be blank"
    end

    it "is invalid with no price" do
      ebook = build_stubbed(:ebook, price: nil)
      expect(ebook).to_not be_valid
      expect(ebook.errors.full_messages).to include "Price can't be blank"
    end
  end

  context "Test enum attributes" do
    it "should have valid statuses" do
      expect(Ebook.statuses.keys).to match_array %w[draft pending live]
    end

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
    it "returns only draft ebooks" do
      draft_ebook = create(:ebook, :draft)
      pending_ebook = create(:ebook, :pending)
      live_ebook = create(:ebook, :live)

      draft_ebooks = Ebook.draft
      expect(draft_ebooks).to include(draft_ebook)
      expect(draft_ebooks).to_not include(pending_ebook)
      expect(draft_ebooks).to_not include(live_ebook)
    end
  end

  context ".pending" do
    it "returns only pending ebooks" do
      draft_ebook = create(:ebook, :draft)
      pending_ebook = create(:ebook, :pending)
      live_ebook = create(:ebook, :live)

      published_ebooks = Ebook.pending
      expect(published_ebooks).to_not include(draft_ebook)
      expect(published_ebooks).to include(pending_ebook)
      expect(published_ebooks).to_not include(live_ebook)
    end
  end

  context ".published" do
    it "returns only live ebooks" do
      draft_ebook = create(:ebook, :draft)
      pending_ebook = create(:ebook, :pending)
      live_ebook = create(:ebook, :live)

      published_ebooks = Ebook.published
      expect(published_ebooks).to_not include(draft_ebook)
      expect(published_ebooks).to_not include(pending_ebook)
      expect(published_ebooks).to include(live_ebook)
    end
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
