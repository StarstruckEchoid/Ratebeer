require 'rails_helper'

describe "Beer" do

  it "can be created on the beer creation page, if given name is non-empty, style is selected, and brewery is selected" do
    brewery = FactoryBot.create(:brewery, name:'TestBrew')

    visit new_beer_path
    fill_in('beer_name', with:'Frosty Test Lager')
    select('Lager', from:'beer_style')
    select('TestBrew', from:'beer_brewery_id')
    expect{ click_button "Create Beer" }.to change{Beer.count}.by(1)
  end
end