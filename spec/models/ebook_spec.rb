require 'rails_helper'


RSpec.describe Ebook, type: :model do
  before(:all) do
    @user = User.create(username: "testing_user", email: "ebook.test.email@email.com", password: "1234", password_confirmation: "1234")
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

    it "should be valid status" do
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
end
