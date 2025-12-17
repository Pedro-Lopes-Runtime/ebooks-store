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

  context "Instantiate Ebook"
  it "is valid with valid attributes" do
    ebook = Ebook.new(author: @author, user: @user, title: "test title", description: "test description")
    expect(ebook).to be_valid
  end

  it "is invalid with no title" do
    ebook = Ebook.new(author: @author, user: @user, description: "test description")
    expect(ebook).to_not be_valid
  end

  it "should have valid statuses" do
    expect(Ebook.statuses.keys).to match_array %w[draft pending live]
  end
end
