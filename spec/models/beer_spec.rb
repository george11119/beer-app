require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.new name: "testbrewery", year: 2000 }

  describe "with invalid parameters" do
    it "is not saved with a no name" do
      beer = Beer.create style: "Lager", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not saved with a no style" do
      beer = Beer.create name: "testbeer", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

  describe "with valid parameters" do
    it "is saved with name and style" do
      beer = Beer.create name: "testbeer", style: "Lager", brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
end
