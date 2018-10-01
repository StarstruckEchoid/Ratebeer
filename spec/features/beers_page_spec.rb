require 'rails_helper'

include Helpers

describe "Beer" do
  describe "on the beer creation page, with a valid style and brewery and while logged in" do
    before :each do
      FactoryBot.create(:user, username: "Ada Lovelace", password: "Ada1", password_confirmation: "Ada1")
      sign_in(username: "Ada Lovelace", password: "Ada1")
      initialise_style_and_brewery
    end

    it "can be created if given name is non-empty" do
      fill_in('beer_name', with: 'Frosty Test Lager')
      expect{ click_button "Create Beer" }.to change{ Beer.count }.by(1)
    end

    it "can't be created, if given name is empty" do
      expect{ click_button "Create Beer" }.to change{ Beer.count }.by(0)
    end
  end
end

private

def initialise_style_and_brewery
  FactoryBot.create(:brewery, name: 'TestBrew')

  visit new_beer_path
  select('Lager', from: 'beer_style')
  select('TestBrew', from: 'beer_brewery_id')
end
