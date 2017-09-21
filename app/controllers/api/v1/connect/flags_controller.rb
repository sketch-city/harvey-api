# frozen_string_literal: true

module Api
  module V1
    module Connect
      class FlagsController < ApplicationController
        include DeviceIdentifiable

        def create
          @marker = ::Connect::Marker.find(params[:marker_id])
          @marker.flag_as_inappropriate!(device_uuid: device_uuid, reason: params[:reason])
          head :no_content
        end
      end
    end
  end
end
