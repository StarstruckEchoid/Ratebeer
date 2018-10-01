require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with a proper username" do
    let(:user){ User.create username: "Corruption" }

    it "doesn't validate purely numerical passwords" do
      user.password = "666666"

      not_valid_and_isnt_saved(user)
    end

    it "doesn't validate too short passwords" do
      user.password = "5Rt"

      not_valid_and_isnt_saved(user)
    end
  end

  describe "user favorites" do
    let(:user){ FactoryBot.create(:user) }

    describe "favorite beer" do
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_beer)
      end

      it "without ratings does not have one" do
        expect(user.favorite_beer).to eq(nil)
      end

      it "is the only rated if only one rating" do
        beer = FactoryBot.create(:beer)
        FactoryBot.create(:rating, score: 20, beer: beer, user: user)

        expect(user.favorite_beer).to eq beer
      end

      it "is the one with highest rating if several rated" do
        create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
        best = create_beer_with_rating({ user: user }, 25)

        expect(user.favorite_beer).to eq(best)
      end
    end

    describe "favorite style" do
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_style)
      end

      it "without ratings does not have one" do
        expect(user.favorite_style).to eq(nil)
      end

      it "is the only rated if only one style rated" do
        style = "Lager"
        beer = FactoryBot.create(:beer, style: style)
        FactoryBot.create(:rating, score: 20, beer: beer, user: user)

        expect(user.favorite_style).to eq style
      end

      it "is the style with highest rated beer, if two beers of two styles rated once each." do
        lager = "Lager"
        paleale = "Pale Ale"
        lagerbeer = FactoryBot.create(:beer, style: lager)
        palealebeer = FactoryBot.create(:beer, style: paleale)

        FactoryBot.create(:rating, score: 20, beer: lagerbeer, user: user)
        FactoryBot.create(:rating, score: 10, beer: palealebeer, user: user)

        expect(user.favorite_style).to eq lager
      end

      it "is the style with the highest average rating otherwise" do
        lager = "Lager"
        paleale = "Pale Ale"
        lagerscores = [19, 18, 20]
        palealescores = [1, 1, 21]
        create_beers_with_style_and_ratings({ user: user }, lager, lagerscores)
        create_beers_with_style_and_ratings({ user: user }, paleale, palealescores)
        expect(user.favorite_style).to eq lager
      end
    end

    describe "favorite brewery" do
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_brewery)
      end

      it "without ratings does not have one" do
        expect(user.favorite_brewery).to eq(nil)
      end

      it "is the only rated if only one brewery rated" do
        brewery = FactoryBot.create(:brewery)
        beer = FactoryBot.create(:beer, brewery: brewery)
        FactoryBot.create(:rating, score: 20, beer: beer, user: user)

        expect(user.favorite_brewery).to eq brewery
      end

      it "is the brewery with highest rated beer, if two beers of two breweries rated once each." do
        brewery1 = FactoryBot.create(:brewery, name: "First Brew")
        brewery2 = FactoryBot.create(:brewery, name: "Double Trouble")
        br1beer = FactoryBot.create(:beer, brewery: brewery1)
        br2beer = FactoryBot.create(:beer, brewery: brewery2)

        FactoryBot.create(:rating, score: 20, beer: br1beer, user: user)
        FactoryBot.create(:rating, score: 10, beer: br2beer, user: user)

        expect(user.favorite_brewery).to eq brewery1
      end

      it "is the brewery with the highest average rating otherwise" do
        brewery1 = FactoryBot.create(:brewery, name: "First Brew")
        brewery2 = FactoryBot.create(:brewery, name: "Double Trouble")
        br1scores = [19, 18, 20]
        br2scores = [1, 1, 21]
        create_beers_with_brewery_and_ratings({ user: user }, brewery1, br1scores)
        create_beers_with_brewery_and_ratings({ user: user }, brewery2, br2scores)
        expect(user.favorite_brewery).to eq brewery1
      end
    end
  end

  private

  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end

  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def create_beers_with_style_and_ratings(object, style, scores)
    scores.each do |score|
      create_beer_with_style_and_rating(object, style, score)
    end
  end

  def create_beer_with_style_and_rating(object, style, score)
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def create_beers_with_brewery_and_ratings(object, brewery, scores)
    scores.each do |score|
      create_beer_with_brewery_and_rating(object, brewery, score)
    end
  end

  def create_beer_with_brewery_and_rating(object, brewery, score)
    beer = FactoryBot.create(:beer, brewery: brewery)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def not_valid_and_isnt_saved(user)
    expect(user).not_to be_valid
    expect(user.save).to be false
    expect(User.all).to be_empty
  end
end
