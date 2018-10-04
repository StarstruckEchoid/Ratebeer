class ApixuApi
  def self.weather_in(city)
    cityc = city.downcase
    Rails.cache.fetch("weather_in_#{cityc}", expires_in: 10.minutes.to_i) { get_weather_in(cityc) }
  end

  def self.get_weather_in(city)
    url = "https://api.apixu.com/v1/current.xml?key=#{key}&q=#{ERB::Util.url_encode(city)}"

    response = HTTParty.get url
    return nil unless weather = response.parsed_response["root"]["current"]["condition"]

    Weather.new(weather)
  end

  def self.key
    raise "APIXU_APIKEY env variable not defined" unless apikey = ENV['APIXU_APIKEY']

    apikey
  end
end
