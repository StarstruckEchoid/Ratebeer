require 'rails_helper'

describe "Places" do
  before :each do
    rig_kumpula_apixu_with_nil
  end

  it "if one is returned by the API, it is shown on the page" do
    rig_kumpula_beer_mapping_with [
      Place.new(name: "Oljenkorsi", id: 1)
    ]

    search_kumpula

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned, they are all shown" do
    rig_kumpula_beer_mapping_with [
      Place.new(name: "Oljenkorsi", id: 1),
      Place.new(name: "Luonnonvakio", id: 2)
    ]

    search_kumpula

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Luonnonvakio"
  end

  it "if none are returned, display notification" do
    rig_kumpula_beer_mapping_with []

    search_kumpula

    expect(page).to have_content "No locations in kumpula"
  end
end

private

def search_kumpula
  visit places_path
  fill_in('city', with: 'kumpula')
  click_button "Search"
end

def rig_kumpula_beer_mapping_with(array)
  allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(array)
end

def rig_kumpula_apixu_with_nil
  allow(ApixuApi).to receive(:weather_in).with("kumpula").and_return(nil)
end