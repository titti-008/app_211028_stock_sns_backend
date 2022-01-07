require "rails-helper"

descride "Users API" do
  it "get all users" do
    FactoryBot.create_list(:user, 10)
  end
end