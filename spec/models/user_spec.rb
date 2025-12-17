require 'rails_helper'

RSpec.describe User, type: :model do
  after(:all) do
    User.destroy_all
  end

  let(:generate_valid_user) { User.new(username: "test_username", email: "test.email@email.com", password: "1234") }

  context "Test user instantiate" do
    it "is valid with valid attributes" do
      expect(generate_valid_user).to be_valid
    end

    it "is invalid with no username" do
      user = User.new(email: "test.email@email.com", password: "1234")
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include "Username can't be blank"
    end

    it "is invalid with no email" do
      user = User.new(username: "test_username", password: "1234")
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include "Email can't be blank"
    end
    it "is invalid with no password" do
      user = User.new(username: "test_username", email: "test.email@email.com")
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
      user = generate_valid_user
      user.save
      expect(user.status).to be_truthy
      user.change_status
      expect(user.status).to be_falsy
      user.change_status
      expect(user.status).to be_truthy
    end
  end

  context "Test attribute uniqueness" do
    it "is invalid if email is already being used" do
      user1 = generate_valid_user
      user1.save
      user2 = User.new(username: "test_username2", email: "test.email@email.com", password: "12345")

      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include "Email has already been taken"
    end

    it "is invalid if usernanme is already being used" do
      user1 = generate_valid_user
      user1.save
      user2 = User.new(username: "test_username", email: "test2.email@email.com", password: "12345")

      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include "Username has already been taken"
    end
  end

  context "Test format validation" do
    it "should validate email format" do
      user = generate_valid_user
      expect(user).to be_valid
      user.email = "test.email.com"
      expect(user).to_not be_valid
      user.email = "test.email@.com"
      expect(user).to_not be_valid
      user.email = "@email.com"
      expect(user).to_not be_valid
    end
  end
end
