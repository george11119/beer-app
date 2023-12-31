class BeermappingApi
  def self.places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{api_key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    begin
      places = response.parsed_response["bmp_locations"]["location"]
    rescue StandardError
      return []
    end

    return [] if places.is_a?(Hash) && places["id"].nil?

    places = [places] if places.is_a?(Hash)
    places.map { |place| Place.new(place) }
  end

  def self.api_key
    "2e7ac340b9b44ac232c45991c1dcd566"
  end
end
