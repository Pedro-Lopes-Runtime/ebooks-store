require 'rails_helper'

RSpec.describe User, type: :model do
  context "Test user instantiate" do
    it "is valid with valid attributes" do
      expect(build_stubbed(:user)).to be_valid
    end

    it "is invalid with no username" do
      user = build_stubbed(:user, username: nil)
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include "Username can't be blank"
    end

    it "is invalid with no email" do
      user = build_stubbed(:user, email: nil)
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include "Email can't be blank"
    end
    it "is invalid with no password" do
      user = build_stubbed(:user, password: nil)
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include "Password can't be blank"
    end
  end

  context "Test enum attributes" do
    it "should have valid user_types" do
      expect(User.user_types.keys).to match_array %w[seller buyer]
    end
  end

  context "Test functionality" do
    it "should enable/disable status" do
      user = build(:user)
      expect(user.status).to eq "enabled"
      user.change_status
      expect(user.status).to eq "disabled"
      user.change_status
      expect(user.status).to eq "enabled"
    end
  end

  context "Test attribute uniqueness" do
    it "is invalid if email is already being used" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)

      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include "Email has already been taken"
    end

    it "is invalid if username is already being used" do
      user1 = create(:user)
      user2 = build(:user, username: user1.username)

      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include "Username has already been taken"
    end
  end

  context "Test format validation" do
    it "should validate email format" do
      user = build_stubbed(:user, email: "test.email@email.com")
      expect(user).to be_valid
      user = build_stubbed(:user, email: "test.email.com")
      expect(user).to_not be_valid
      user = build_stubbed(:user, email: "test.email@.com")
      expect(user).to_not be_valid
      user = build_stubbed(:user, email: "@email.com")
      expect(user).to_not be_valid
    end
  end

  context "Test association" do
    it { should have_many(:ebooks).dependent(:destroy) }
    it { should have_many(:purchases).dependent(:destroy) }
    it { should have_many(:purchased_ebooks).through(:purchases) }
  end

  context "Test instance methods" do
    it ".enable! should set status to enabled" do
      user = build_stubbed(:user, :disabled)
      expect(user.status).to eq "disabled"
      user.enable!
      expect(user.status).to eq "enabled"
    end

    it ".disable! should set status to disabled" do
      user = build_stubbed(:user)
      expect(user.status).to eq "enabled"
      user.disable!
      expect(user.status).to eq "disabled"
    end

    it ".enabled? should return true or false" do
      user = build_stubbed(:user)
      expect(user.enabled?).to be true
      user = build_stubbed(:user, :disabled)
      expect(user.enabled?).to be false
    end
  end

  context "Test callbacks" do
    it "normailizes email" do
      non_normalized_email = "NoN.NoRmAlIzEd@EMAIL.com"
      user = create(:user, email: non_normalized_email)
      expect(user.email).to eq(non_normalized_email.downcase)
    end
  end
end
