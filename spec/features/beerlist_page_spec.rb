require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      Capybara.register_driver :selenium do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: { args: ['headless', 'disable-gpu']  }
        )
      end

      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
    visit beerlist_path
  end

  it "shows one known beer", js:true do
    expect(page).to have_content "Nikolai"
  end

  it "lists beers in alphabetical order by default", js:true do
    expect(page).to have_content /Fastenbier[\s\S]*Lechte Weisse[\s\S]*Nikolai/
  end

  it "sorts by style when clicking on 'Style'.", js:true do
    click_on("Style")
    expect(page).to have_content /Lager[\s\S]*Rauchbier[\s\S]*Weizen/
  end

  it "sorts by brewery when clicking on 'Brewery'.", js:true do
    click_on("Brewery")
    expect(page).to have_content /Ayinger[\s\S]*Koff[\s\S]*Schlenkerla/
  end
end