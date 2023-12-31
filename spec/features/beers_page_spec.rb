require "rails_helper"

describe "Beers page" do
  describe "when creating beers" do
    let!(:user) { FactoryBot.create :user, username: "john", password: "Hunter2" }
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }

    describe "when not signed in" do
      it "doesnt allow beers to be created" do
        visit new_beer_path
        expect(page).to have_content("you should be signed in")
      end
    end

    describe "when signed in" do
      before :each do
        sign_in(username: "john", password: "Hunter2")
      end

      it "doesnt allow beers with empty names to be created" do
        visit new_beer_path
        click_button("Create Beer")
        expect(page).to have_content("Name can't be blank")
      end

      it "allow beers to be created when names are provided" do
        visit new_beer_path
        select("Lager", from: "beer[style]")
        fill_in("beer[name]", with: "iso 3")

        expect(Beer.count).to eq(0)
        click_button("Create Beer")
        expect(Beer.count).to eq(1)

        expect(page).to have_content("Beer was successfully created")
        expect(Beer.first.name).to eq("iso 3")
        expect(Beer.first.style).to eq("Lager")
      end
    end
  end
end