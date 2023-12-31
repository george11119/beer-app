require 'rails_helper'
include Helpers

describe "User" do
  describe "who is signing up" do
    before :each do
      visit signup_path
    end

    it "is added to the system when valid credentials are provided" do
      fill_in "user_username", with: "will"
      fill_in "user_password", with: "Hello11"
      fill_in "user_password_confirmation", with: "Hello11"

      expect(User.count).to eq(0)
      click_button("Create User")
      expect(User.count).to eq(1)
    end
  end

  describe "who has signed up" do
    before :each do
      FactoryBot.create :user, username: "john", password: "Hunter2", password_confirmation: "Hunter2"
    end

    it "can sign in with right credentials" do
      sign_in(username: "john", password: "Hunter2")
      expect(page).to have_content "Welcome back, john!"
    end

    it "is redirected back to signin page if wrong credentials are given" do
      sign_in(username: "john", password: "wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content "Username or password is incorrect"
    end
  end
end