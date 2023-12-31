require "rails_helper"

describe "Breweries page" do
  it "should not have any before been created" do
    visit breweries_path
    expect(page).to have_content "Listing breweries"
    expect(page).to have_content "Number of breweries: 0"
  end

  describe "breweries exist" do
    before :each do
      @breweries = ["Koff", "Kahf", "Kvma"]
      year = 1500
      @breweries.each_with_index do |brewery_name, i|
        FactoryBot.create(:brewery, name: brewery_name, year: year + i)
      end
      visit breweries_path
    end

    it "lists the existing breweries and their total number" do
      expect(page).to have_content "Number of breweries: #{@breweries.count}"
      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it "allows the user to navigate to a page of a brewery" do
      click_link "Koff"

      expect(page).to have_content("Koff")
      expect(page).to have_content("Year: 1500")
    end
  end
end