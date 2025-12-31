require 'rails_helper'
require 'sidekiq/testing'
include ActiveJob::TestHelper

RSpec.describe Purchase, :with_ebook, type: :model do
  context "Test association" do
    it { should belong_to(:user) }
    it { should belong_to(:ebook) }
    it { should have_one(:seller).through(:ebook) }
  end

  context "when purchased is created" do
    it "should trigger notifications" do
      expect(HardJob.jobs.size).to eq 0
      create(:purchase, ebook: ebook)
      expect(HardJob.jobs.size).to eq 1
    end

    it "should update ebook statistics" do
      expect { create(:purchase, ebook: ebook) }.to change { ebook.ebook_statistic.purchases }.by 1
    end

    it "should record correct price" do
      purchase = create(:purchase, ebook: ebook, price: ebook.price)

      expect(purchase.price).to eq(ebook.price)
      ebook.price = 100
      expect(purchase.price).to_not eq(ebook.price)
    end

    it "creates visitor_statistics with the correct data" do
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
