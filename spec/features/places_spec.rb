require "rails_helper"

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in)
      .with("kumpula")
      .and_return([Place.new(name: "Oljenkorsi", id: 1)])

    visit places_path
    fill_in("city", with: "kumpula")
    click_button("Search")

    expect(page).to have_content("Oljenkorsi")
  end

  it "if many are returned by API, all returned places are displayed" do
    place_names = ["beer place", "return value", "night club"]
    allow(BeermappingApi).to receive(:places_in)
      .with("munich")
      .and_return(place_names.map { |name, i| Place.new(name: name, id: i) })

    visit places_path
    fill_in("city", with: "munich")
    click_button("Search")

    expect(page).to have_content("beer place")
    expect(page).to have_content("return value")
    expect(page).to have_content("night club")
  end

  it "if none are returned by API, no results message is displayed" do
    allow(BeermappingApi).to receive(:places_in).with("a").and_return([])

    visit places_path
    fill_in("city", with: "a")
    click_button("Search")

    expect(page).to have_content("No locations in 'a'")
  end
end
