require "rails_helper"
include Helpers

describe "Ratings page" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "karhu", brewery: brewery }
  let!(:user1) { FactoryBot.create :user, username: "john", password: "Hunter2", password_confirmation: "Hunter2" }
  let!(:user2) { FactoryBot.create :user, username: "will", password: "Hunter2", password_confirmation: "Hunter2" }

  before :each do
    sign_in(username: "john", password: "Hunter2")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select("iso 3", from: "rating[beer_id]")
    fill_in("rating[score]", with: "15")

    expect(Rating.count).to eq(0)
    click_button("Create Rating")
    expect(Rating.count).to eq(1)

    expect(user1.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "viewing ratings" do
    let!(:rating1) { FactoryBot.create :rating, score: 50, beer: beer1, user: user1 }
    let!(:rating2) { FactoryBot.create :rating, score: 5, beer: beer2, user: user1 }
    let!(:rating3) { FactoryBot.create :rating, score: 30, beer: beer1, user: user2 }

    it "on all ratings page shows the correct ratings and number of ratings that exist" do
      visit ratings_path

      expect(page).to have_content("Number of ratings: #{Rating.count}")
      expect(page).to have_content("name: iso 3, rating: 50")
      expect(page).to have_content("name: karhu, rating: 5")
    end

    it "on users page shows only the selected users personal ratings and not ratings made by other users" do
      visit user_path(user1)
      expect(page).to have_content("iso 3 - Koff 50")
      expect(page).to have_content("karhu - Koff 5")
      expect(page).not_to have_content("iso 3 - Koff 30")

      visit user_path(user2)
      expect(page).not_to have_content("iso 3 - Koff 50")
      expect(page).not_to have_content("karhu - Koff 5")
      expect(page).to have_content("iso 3 - Koff 30")
    end
  end

  describe "deleting ratings" do
    let!(:rating1) { FactoryBot.create :rating, score: 50, beer: beer1, user: user1 }
    let!(:rating2) { FactoryBot.create :rating, score: 5, beer: beer2, user: user1 }

    it "users can delete their own ratings" do
      visit user_path(user1)
      expect(user1.ratings.count).to eq(2)
      page.find("li", text: "iso 3 - Koff 50").click_link("Delete")
      expect(user1.ratings.count).to eq(1)
    end
  end
end