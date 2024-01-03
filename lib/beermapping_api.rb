class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.day) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{api_key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places["id"].nil?

    places = [places] if places.is_a?(Hash)
    places.map { |place| Place.new(place) }
  end

  def self.get_place(location_id)
    url = "http://beermapping.com/webservice/locquery/#{api_key}/"

    response = HTTParty.get "#{url}#{location_id}"
    Place.new(response.parsed_response["bmp_locations"]["location"])
  end

  def self.api_key
    "2e7ac340b9b44ac232c45991c1dcd566"
  end
end
