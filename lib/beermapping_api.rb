class BeermappingApi
  def self.places_in(city)
    cityc = city.downcase
    Rails.cache.fetch("places_in_#{cityc}", expires_in: 1.week.to_i) { get_places_in(cityc) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.place_by_id(index)
    Rails.cache.fetch("place#{index}", expires_in: 1.day.to_i) { get_place_by_id(index) }
  end

  def self.get_place_by_id(index)
    url = "https://beermapping.com/webservice/locquery/#{key}/"
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(index)}"
    place = response.parsed_response["bmp_locations"]["location"]
    Place.new(place)
  end

  def self.key
    raise "BEERMAPPING_APIKEY env variable not defined" unless apikey = ENV['BEERMAPPING_APIKEY']

    apikey
  end
end
