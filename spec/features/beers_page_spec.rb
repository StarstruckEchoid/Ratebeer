require 'rails_helper'

describe "Beer" do

  describe "on the beer creation page, with a valid style and brewery" do
    before :each do
      initialise_style_and_brewery
    end

    it "can be created if given name is non-empty" do
      fill_in('beer_name', with:'Frosty Test Lager')
      expect{ click_button "Create Beer" }.to change{Beer.count}.by(1)
    end

    it "can't be created, if given name is empty" do
      expect{ click_button "Create Beer" }.to change{Beer.count}.by(0)
    end
  end
end

private

def initialise_style_and_brewery
  brewery = FactoryBot.create(:brewery, name:'TestBrew')

  visit new_beer_path
  select('Lager', from:'beer_style')
  select('TestBrew', from:'beer_brewery_id')
end