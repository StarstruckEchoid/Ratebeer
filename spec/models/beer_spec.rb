require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a proper brewery" do
    let(:brewery){ Brewery.create name: "TestBrew", year: "2000" }
    describe "and with a proper name and style" do
      let(:beer){ Beer.new name: "FooBeer", style: "Lager", brewery_id: brewery.id }

      it "is valid" do
        expect(beer).to be_valid
      end

      it "is saved" do
        expect(beer.save).to be true
      end
    end

    describe "and with a proper style but no name" do
      let(:beer){ Beer.new style: "Lager", brewery_id: brewery.id }

      it "isn't valid" do
        expect(beer).to_not be_valid
      end
      it "isn't saved" do
        expect(beer.save).to be false
      end
    end

    describe "and with a proper name but no style" do
      let(:beer){ Beer.new name: "FooBeer", brewery_id: brewery.id }

      it "isn't valid" do
        expect(beer).to_not be_valid
      end
      it "isn't saved" do
        expect(beer.save).to be false
      end
    end
  end
end
