require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Purchase, type: :model do
  let(:instactiate_dependancy_models) do
    @seller = User.create(username: "seller_user", email: "seller.email@email.com", password: "1234", balance: 100)
    @buyer = User.create(username: "buyer_user", email: "buyer.email@email.com", password: "1234")
    @author = Author.create(name: "test author")
    @ebook = Ebook.create(author: @author, user: @seller, title: "test title",
                          description: "test description", price: 29.99)
    Thread.current[:request] = { ip: "123.123.123.123", browser: "Chrome", location: "Portugal" }
  end

  context "Test association" do
    it { should belong_to(:user) }
    it { should belong_to(:ebook) }
    it { should have_one(:seller).through(:ebook) }
  end

  context "when purchased is created" do
    it "should trigger notifications" do
      instactiate_dependancy_models

      mail_double = double(deliver_later: true)

      allow(UserMailer).to receive(:with).with(ebook: @ebook).and_return(UserMailer)
      allow(UserMailer).to receive(:sale_commission).and_return(mail_double)
      allow(UserMailer).to receive(:ebook_statistics).and_return(mail_double)

      Purchase.create(user: @buyer, ebook: @ebook, price: @ebook.price)

      expect(UserMailer).to have_received(:with).with(ebook: @ebook).twice
      expect(UserMailer).to have_received(:sale_commission)
      expect(UserMailer).to have_received(:ebook_statistics)
      expect(mail_double).to have_received(:deliver_later).twice
    end

    it "should update ebook statistics" do
      instactiate_dependancy_models

      expect { Purchase.create(user: @buyer, ebook: @ebook, price: @ebook.price) }.to change { @ebook.ebook_statistic.purchases }.by 1
      expect { Purchase.create(user: @buyer, ebook: @ebook, price: @ebook.price) }.to change { @ebook.ebook_statistic.visitor_statistics.count }.by 1
    end

    it "should record correct price" do
      instactiate_dependancy_models
      purchase = Purchase.create(user: @buyer, ebook: @ebook, price: @ebook.price)

      expect(purchase.price).to eq(@ebook.price)
      @ebook.price = 100
      expect(purchase.price).to_not eq(@ebook.price)
    end

    it "creates visitor_statistics with the correct data" do
      instactiate_dependancy_models

      Purchase.create(user: @buyer, ebook: @ebook, price: @ebook.price)

      visitor = @ebook.ebook_statistic.visitor_statistics.last

      expect(visitor.ip).to eq("123.123.123.123")
      expect(visitor.browser).to eq("Chrome")
      expect(visitor.location).to eq("Portugal")
    end
  end
end
