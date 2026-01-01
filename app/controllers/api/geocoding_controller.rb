module Api
  class GeocodingController < ApplicationController
    before_action :authenticate_driver!
    skip_before_action :verify_authenticity_token

    def reverse_geocode
      latitude = params[:latitude]
      longitude = params[:longitude]

      if latitude.blank? || longitude.blank?
        render json: { error: "座標が指定されていません" }, status: :bad_request
        return
      end

      address = GeocodingService.reverse_geocode(latitude, longitude)

      if address
        render json: { address: address }
      else
        render json: { error: "住所の取得に失敗しました" }, status: :unprocessable_entity
      end
    end
  end
end
