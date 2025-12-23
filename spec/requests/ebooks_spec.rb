require 'rails_helper'

RSpec.describe "Ebooks", type: :request do
  def stub_auth_for(ebook)
    allow_any_instance_of(ApplicationController).to receive(:require_authentication).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user) do |controller|
      controller.instance_variable_set(:@current_user, ebook.user)
      ebook.user
    end
  end

  describe "GET /index" do
    it "list published ebooks" do
      ebook = create(:ebook, :published)

      stub_auth_for(ebook)

      allow(Ebook).to receive(:published).and_return(Ebook.where(id: ebook.id))

      get ebooks_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(CGI.escapeHTML(ebook.title))
    end
  end
  describe "GET /show" do
    it "records view" do
      ebook = create(:ebook)

      stub_auth_for(ebook)

      allow(Ebook).to receive(:find).and_return(ebook)

      expect_any_instance_of(EbookStatistic).to receive(:update_visits)

      get ebook_path(ebook)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(CGI.escapeHTML(ebook.title))
    end
  end

  describe "GET /preview" do
    it "redirects to the preview PDF and updates preview_views" do
      ebook = create(:ebook, :with_pdf)

      stub_auth_for(ebook)

      allow(Ebook).to receive(:find).and_return(ebook)

      expect_any_instance_of(EbookStatistic).to receive(:update_preview_views)

      get preview_ebook_path(ebook)

      expect(response).to have_http_status(:found)
    end
  end

  describe "POST /purchase" do
    it "flashes error message and redirects back if an error is raised" do
      ebook = create(:ebook)

      ebook.user.update!(balance: 100)

      stub_auth_for(ebook)

      allow(Ebook).to receive(:find).and_return(ebook)
      allow(Purchase).to receive(:create).and_raise(StandardError.new("Purchase failed"))

      post purchase_ebook_path(ebook)

      expect(response).to redirect_to("/")
      expect(flash[:alert]).to eq("An error occurred and the purchase could not be completed. Please try again later")
    end

    it "handles email delivery failures by flashing an error and redirecting to root" do
      ebook = create(:ebook)

      ebook.user.update!(balance: 100)

      stub_auth_for(ebook)

      failing_mail = double("Mail")
      allow(failing_mail).to receive(:deliver_later).and_raise(StandardError.new("Email failed"))

      allow(UserMailer).to receive(:with).with(ebook: ebook).and_return(UserMailer)
      allow(UserMailer).to receive(:sale_commission).and_return(failing_mail)
      allow(UserMailer).to receive(:ebook_statistics).and_return(failing_mail)

      post purchase_ebook_path(ebook)

      expect(response).to redirect_to("/")
      expect(flash[:alert]).to eq("An error occurred and the purchase could not be completed. Please try again later")
    end
  end
end
