require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a name and email" do
    user = User.new(name: "Nick", email: "nick@example.com")
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(email: "nick@example.com")
    expect(user).not_to be_valid
  end

  it "is invalid without an email" do
    user = User.new(name: "Nick")
    expect(user).not_to be_valid
  end
end
