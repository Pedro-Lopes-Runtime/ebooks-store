require 'rails_helper'

RSpec.describe EbooksController, type: :controller do
  describe "GET #new", :authenticated do
    it "returns success" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create", :authenticated do
    it "returns success" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #index", :authenticated_seller do
    it "returns seller's ebooks" do
      get :index
      expect(assigns(:ebooks)).to match_array(seller_ebooks)
    end
  end
end
