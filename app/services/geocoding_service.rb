class GeocodingService
  require "net/http"
  require "json"

  BASE_URL = "https://maps.googleapis.com/maps/api/geocode/json"

  # 座標から住所を取得
  def self.reverse_geocode(latitude, longitude)
    api_key = ENV["GOOGLE_MAPS_API_KEY"]
    return nil if api_key.blank? || api_key == "your_api_key_here" || api_key == "your_google_maps_api_key_here"

    uri = URI(BASE_URL)
    params = {
      latlng: "#{latitude},#{longitude}",
      key: api_key,
      language: "ja"
    }
    uri.query = URI.encode_www_form(params)

    begin
      response = Net::HTTP.get_response(uri)
      return nil unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      return nil unless data["status"] == "OK"

      # 最も詳細な住所を返す
      data["results"]&.first&.dig("formatted_address")
    rescue StandardError => e
      Rails.logger.error "Geocoding error: #{e.message}"
      nil
    end
  end

  # 住所から座標を取得
  def self.geocode(address)
    api_key = ENV["GOOGLE_MAPS_API_KEY"]
    return nil if api_key.blank? || api_key == "your_api_key_here" || api_key == "your_google_maps_api_key_here"

    uri = URI(BASE_URL)
    params = {
      address: address,
      key: api_key,
      language: "ja"
    }
    uri.query = URI.encode_www_form(params)

    begin
      response = Net::HTTP.get_response(uri)
      return nil unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      return nil unless data["status"] == "OK"

      location = data["results"]&.first&.dig("geometry", "location")
      return nil unless location

      {
        latitude: location["lat"],
        longitude: location["lng"],
        formatted_address: data["results"]&.first&.dig("formatted_address")
      }
    rescue StandardError => e
      Rails.logger.error "Geocoding error: #{e.message}"
      nil
    end
  end
end
