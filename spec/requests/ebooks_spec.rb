require 'rails_helper'

RSpec.describe "Ebooks", type: :request do
  describe "GET /index" do
    it "list published ebooks", :authenticated do
      ebook = create(:ebook, :published)

      get ebooks_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(CGI.escapeHTML(ebook.title))
    end

    it "returns seller's ebooks", :authenticated_seller_with_ebooks do
      get ebooks_path

      expect(assigns(:ebooks).to_a).to match_array(seller_ebooks)
    end
  end

  describe "GET #new", :authenticated do
    it "returns success" do
      get new_ebook_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe "POST /create", :authenticated_seller do
    it "returns success" do
      expect {
        post ebooks_path,
          params: {
            ebook: attributes_for(
              :ebook,
              user_id: current_user.id,
              author_id: create(:author).id
            )
          }
        }.to change { Ebook.count }.by 1

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(ebook_path(Ebook.last))
    end
  end

  describe "GET /show", :authenticated_ebook_owner do
    it "records view" do
      allow(Ebook).to receive(:find).and_return(ebook)

      expect_any_instance_of(EbookStatistic).to receive(:update_visits)

      get ebook_path(ebook)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(CGI.escapeHTML(ebook.title))
    end
  end

  describe "GET /preview", :authenticated do
    it "redirects to the preview PDF and updates preview_views" do
      ebook = create(:ebook, :with_pdf)

      allow(Ebook).to receive(:find).and_return(ebook)

      expect_any_instance_of(EbookStatistic).to receive(:update_preview_views)

      get preview_ebook_path(ebook)

      expect(response).to have_http_status(:found)
    end
  end

  describe "POST /purchase", :with_purchase_setup do
    it "flashes error message and redirects back if an error is raised" do
      allow(Ebook).to receive(:find).and_return(ebook)
      allow(Purchase).to receive(:create).and_raise(StandardError.new("Purchase failed"))

      post purchase_ebook_path(ebook)

      expect(response).to redirect_to("/")
      expect(flash[:alert]).to eq("An error occurred and the purchase could not be completed. Please try again later")
    end

    it "handles email delivery failures by flashing an error and redirecting to root" do
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
