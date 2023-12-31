require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "john1"

    expect(user.username).to eq("john1")
  end

  describe "without a proper password" do
    it "is not saved when password is empty" do
      user = User.create username: "john1"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is not saved when password is too short" do
      user = User.create username: "john1", password: "aa"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is not saved when password has no capital letter" do
      user = User.create username: "john1", password: "hunter2"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is not saved when password has no number" do
      user = User.create username: "john1", password: "Huntertwo"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved with proper username and password" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "with a proper password and 2 ratings, has the correct rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has a method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rated" do
      beer = create_beer_with_rating({ user: user }, 20)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the highest rated beer if multiple beers rated" do
      create_beers_with_many_ratings({ user: user }, 23, 13, 43, 29, 5)
      best_beer = create_beer_with_rating({ user: user }, 50)

      expect(user.favorite_beer).to eq(best_beer)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "returns nil if ratings are empty" do
      expect(user.favorite_style).to eq(nil)
    end

    it "returns the style and average rating of the only rated beer if there is only one rating" do
      create_scores({ user: user }, { style: "Lager", score: 10})

      expect(user.favorite_style).to eq("Lager")
    end

    it "returns the style and average rating whose beers have the highest average rating if there are multiple ratings" do
      create_scores({ user: user },
                    { style: "Lager", score: 16},
                    { style: "Weizen", score: 22},
                    { style: "Pale ale", score: 25},
                    { style: "Weizen", score: 33},
                    { style: "Lager", score: 11})

      expect(user.favorite_style).to eq("Weizen")
    end
  end

  describe "favorite_brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "returns nil if ratings are empty" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "returns the brewery and average rating of the only rated brewery if there is only one rating" do
      brewery = create_brewery_with_scores({user: user}, "best brewery", [10, 20, 30])

      expect(user.favorite_brewery).to eq(brewery.name)
    end

    it "returns the brewery and average rating whose brewery have the highest average rating if there are multiple ratings" do
      create_brewery_with_scores({user: user}, "bad brewery 1", [10, 20, 30, 10, 10])
      create_brewery_with_scores({user: user}, "bad brewery 2", [10, 50, 30, 20])
      best_brewery = create_brewery_with_scores({user: user}, "best brewery", [40, 40, 40])

      expect(user.favorite_brewery).to eq(best_brewery.name)
    end
  end
end

def create_brewery_with_scores(object, name, scores)
  brewery = FactoryBot.create(:brewery, name: name)

  scores.each do |score|
    beer = FactoryBot.create(:beer, brewery: brewery)
    FactoryBot.create(:rating, score: score, beer: beer, user: object[:user])
  end

  brewery
end

def create_scores(object, *scores_and_styles)
  scores_and_styles.each do |p|
    beer = FactoryBot.create(:beer, style: p[:style])
    FactoryBot.create(:rating, score: p[:score], beer: beer, user: object[:user])
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)

  FactoryBot.create(:rating, score: score, beer: beer, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
