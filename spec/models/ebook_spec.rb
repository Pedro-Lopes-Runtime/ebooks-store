require 'rails_helper'


RSpec.describe Ebook, type: :model do
  before(:all) do
    @user = User.create(username: "testing_user", email: "test.email@email.com", password: "1234")
    @author = Author.create(name: "test author")
  end

  after(:all) do
    @user.destroy
    @author.destroy
  end

  let(:generate_valid_ebook) { Ebook.new(author: @author, user: @user, title: "test title", description: "test description", price: 29.99) }

  context "Instantiate Ebook" do
    it "is valid with valid attributes" do
      expect(generate_valid_ebook).to be_valid
    end

    it "is invalid with no title" do
      ebook = Ebook.new(author: @author, user: @user, description: "test description", price: 29.99)
      expect(ebook).to_not be_valid
      expect(ebook.errors.full_messages).to include "Title can't be blank"
    end

    it "is invalid with no description" do
      ebook = Ebook.new(author: @author, user: @user, title: "test title", price: 29.99)
      expect(ebook).to_not be_valid
      expect(ebook.errors.full_messages).to include "Description can't be blank"
    end

    it "is invalid with no price" do
      ebook = Ebook.new(author: @author, user: @user, description: "test description", title: "test title")
      expect(ebook).to_not be_valid
      expect(ebook.errors.full_messages).to include "Price can't be blank"
    end
  end

  context "Test enum attributes" do
    it "should have valid statuses" do
      expect(Ebook.statuses.keys).to match_array %w[draft pending live]
    end

    it "should have valid status" do
      ebook = generate_valid_ebook
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
      ebook = generate_valid_ebook
      expect(generate_valid_ebook).to be_valid
      ebook.price = 0
      expect(generate_valid_ebook).to be_valid
      ebook.price = -10
      expect(generate_valid_ebook).to_not be_valid
    end
  end

  context "Test association" do
    it { should belong_to(:user) }
    it { should belong_to(:author) }
    it { should have_many(:purchases) }
  end

  context ".draft" do
    it "returns only draft ebooks" do
      draft_ebook = Ebook.create(title: "Draft Ebook", author: @author, user: @user, description: "test description", price: 29.99)
      pending_ebook = Ebook.create(title: "Live Ebook", status: "pending", author: @author, user: @user, description: "test description", price: 29.99)
      live_ebook = Ebook.create(title: "Live Ebook", status: "live", author: @author, user: @user, description: "test description", price: 29.99)

      published_ebooks = Ebook.draft
      expect(published_ebooks).to include(draft_ebook)
      expect(published_ebooks).to_not include(pending_ebook)
      expect(published_ebooks).to_not include(live_ebook)
    end
  end

  context ".pending" do
    it "returns only pending ebooks" do
      draft_ebook = Ebook.create(title: "Draft Ebook", author: @author, user: @user, description: "test description", price: 29.99)
      pending_ebook = Ebook.create(title: "Live Ebook", status: "pending", author: @author, user: @user, description: "test description", price: 29.99)
      live_ebook = Ebook.create(title: "Live Ebook", status: "live", author: @author, user: @user, description: "test description", price: 29.99)

      published_ebooks = Ebook.pending
      expect(published_ebooks).to_not include(draft_ebook)
      expect(published_ebooks).to include(pending_ebook)
      expect(published_ebooks).to_not include(live_ebook)
    end
  end

  context ".published" do
    it "returns only live ebooks" do
      draft_ebook = Ebook.create(title: "Draft Ebook", author: @author, user: @user, description: "test description", price: 29.99)
      pending_ebook = Ebook.create(title: "Live Ebook", status: "pending", author: @author, user: @user, description: "test description", price: 29.99)
      live_ebook = Ebook.create(title: "Live Ebook", status: "live", author: @author, user: @user, description: "test description", price: 29.99)

      published_ebooks = Ebook.published
      expect(published_ebooks).to_not include(draft_ebook)
      expect(published_ebooks).to_not include(pending_ebook)
      expect(published_ebooks).to include(live_ebook)
    end
  end

  context ".by_seller" do
    it "returns only ebooks from the seller" do
      user_ebook = Ebook.create(title: "User Ebook", author: @author, user: @user, description: "test description", price: 29.99)
      seller2 = User.create(username: "seller2_username", email: "seller2.email@email.com", password: "1234")
      seller2_ebook = Ebook.create(title: "Seller2 Ebook", author: @author, user: seller2, description: "test description", price: 29.99)

      user_ebooks = Ebook.by_seller(@user)
      expect(user_ebooks).to include(user_ebook)
      expect(user_ebooks).to_not include(seller2_ebook)
    end
  end

  context "published.by_seller" do
    it "returns only live ebooks from the seller" do
      draft_user_ebook = Ebook.create(title: "User Ebook 1", author: @author, user: @user, description: "test description", price: 29.99)
      live_user_ebook = Ebook.create(title: "User Ebook 1", status: "live", author: @author, user: @user, description: "test description", price: 29.99)
      seller2 = User.create(username: "seller2_username", email: "seller2.email@email.com", password: "1234")
      seller2_ebook = Ebook.create(title: "Seller2 Ebook", status: "live", author: @author, user: seller2, description: "test description", price: 29.99)

      published_user_ebooks = Ebook.published.by_seller(@user)
      expect(published_user_ebooks).to include(live_user_ebook)
      expect(published_user_ebooks).to_not include(draft_user_ebook)
      expect(published_user_ebooks).to_not include(seller2_ebook)
    end
  end

  context "Test instance methods" do
    it ".publish! should change status from pending to live" do
      draft_ebook = Ebook.create(title: "User Ebook 1", author: @author, user: @user, description: "test description", price: 29.99)
      pending_ebook = Ebook.create(title: "User Ebook 1", author: @author, user: @user, description: "test description", price: 29.99, status: "pending")

      draft_ebook.publish!
      expect(draft_ebook.status).to_not eq "live"
      pending_ebook.publish!
      expect(pending_ebook.status).to eq "live"
    end

    it ".submit_for_review! should change status from draft to pending" do
      draft_ebook = Ebook.create(title: "User Ebook 1", author: @author, user: @user, description: "test description", price: 29.99)
      live_ebook = Ebook.create(title: "User Ebook 1", author: @author, user: @user, description: "test description", price: 29.99, status: "live")

      draft_ebook.submit_for_review!
      expect(draft_ebook.status).to eq "pending"
      live_ebook.submit_for_review!
      expect(live_ebook.status).to_not eq "pending"
    end

    it ".view_count return ebook views" do
      ebook = generate_valid_ebook
      ebook.ebook_statistic = EbookStatistic.new
      ebook.save

      expect(ebook.view_count).to eq 0
      ebook.ebook_statistic.visits += 1
      expect(ebook.view_count).to eq 1
    end

    it ".purchase_count return ebook purchases" do
      ebook = generate_valid_ebook
      ebook.ebook_statistic = EbookStatistic.new
      ebook.save

      expect(ebook.purchase_count).to eq 0
      ebook.ebook_statistic.purchases += 1
      expect(ebook.purchase_count).to eq 1
    end
  end
end
