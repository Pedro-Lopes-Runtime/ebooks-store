require 'rails_helper'

RSpec.describe User, type: :model do
  let(:generate_valid_user) { User.new(username: "test_username", email: "test.email@email.com", password: "1234") }
  context "Instantiate User"
  it "is valid with valid attributes" do
    expect(generate_valid_user).to be_valid
  end

  it "is invalid with no username" do
    user = User.new(email: "test2.email@email.com", password: "1234")
    expect(user).to_not be_valid
  end

  it "is invalid with no email" do
    user = User.new(username: "test_username", password: "1234")
    expect(user).to_not be_valid
  end
  it "is invalid with no password" do
    user = User.new(username: "test_username", email: "test3.email@email.com")
    expect(user).to_not be_valid
  end

  it "should have valid user_types" do
    expect(User.user_types.keys).to match_array %w[seller buyer]
  end

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
