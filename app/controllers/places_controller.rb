class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def search
    city = params[:city]
    @places = BeermappingApi.places_in(city)
    @weather = ApixuApi.weather_in(city)
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  private

  def set_place
    @place = BeermappingApi.place_by_id(params[:id])
  end
end
