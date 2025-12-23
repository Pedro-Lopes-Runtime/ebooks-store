require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Purchase, type: :model do
  context "Test association" do
    it { should belong_to(:user) }
    it { should belong_to(:ebook) }
    it { should have_one(:seller).through(:ebook) }
  end

  context "when purchased is created" do
    it "should trigger notifications" do
      ebook = create(:ebook)

      mail_double = double(deliver_later: true)

      allow(UserMailer).to receive(:with).with(ebook: ebook).and_return(UserMailer)
      allow(UserMailer).to receive(:sale_commission).and_return(mail_double)
      allow(UserMailer).to receive(:ebook_statistics).and_return(mail_double)

      create(:purchase, ebook: ebook)

      expect(UserMailer).to have_received(:with).with(ebook: ebook).twice
      expect(UserMailer).to have_received(:sale_commission)
      expect(UserMailer).to have_received(:ebook_statistics)
      expect(mail_double).to have_received(:deliver_later).twice
    end

    it "should update ebook statistics" do
      ebook = create(:ebook)

      expect { create(:purchase, ebook: ebook) }.to change { ebook.ebook_statistic.purchases }.by 1
    end

    it "should record correct price" do
      ebook = create(:ebook)
      purchase = create(:purchase, ebook: ebook, price: ebook.price)

      expect(purchase.price).to eq(ebook.price)
      ebook.price = 100
      expect(purchase.price).to_not eq(ebook.price)
    end

    it "creates visitor_statistics with the correct data" do
      ebook = create(:ebook)

      request_data = { ip: "123.123.123.123", browser: "Chrome", location: "Portugal" }

      purchase = build(:purchase, ebook: ebook)
      allow(purchase).to receive(:update_ebook_statistics) do
        purchase.ebook.log_visitor(request_data)
      end

      expect { purchase.save }.to change { ebook.ebook_statistic.visitor_statistics.count }.by 1

      visitor = ebook.ebook_statistic.visitor_statistics.last

      expect(visitor.ip).to eq("123.123.123.123")
      expect(visitor.browser).to eq("Chrome")
      expect(visitor.location).to eq("Portugal")
    end
  end
end
