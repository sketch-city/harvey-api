# frozen_string_literal: true

module Api
  module V1
    module Connect
      class MarkersController < ApplicationController
        include DeviceIdentifiable

        def index
          @filters = {}
          @markers = ::Connect::Marker.unresolved.not_flagged.all
          apply_filters
        end

        def create
          @marker = ::Connect::Marker.new(marker_params.merge(device_uuid: device_uuid))
          if @marker.save
            render :show, status: :created, location: api_v1_connect_marker_url(@marker)
          else
            render json: @marker.errors, status: :unprocessable_entity
          end
        end

        def update
          @marker = ::Connect::Marker.find_by!(id: params[:id], device_uuid: device_uuid)
          if @marker.update(marker_params)
            render :show, status: :ok, location: api_v1_connect_marker_url(@marker)
          else
            render json: @marker.errors, status: :unprocessable_entity
          end
        end

        private

        def apply_filters
          category_filter
          device_uuid_filter
          location_filter
          limit_filter
          type_filter
        end

        def category_filter
          return unless params[:category].present?
          @filters[:category] = params[:category]
          @markers = @markers.by_category(params[:category])
        end

        def device_uuid_filter
          return unless params[:device_uuid].present?
          @filters[:device_uuid] = device_uuid
          @markers = @markers.by_device_uuid(device_uuid)
        end

        def location_filter
          return unless params[:lat].present? && params[:lon].present?
          location = params.values_at(:lat, :lon)
          @filters[:lat], @filters[:lon] = location
          @filters[:rad] = params.fetch(:rad, 10).to_i
          @markers = @markers.near(location, @filters[:rad])
        end

        def limit_filter
          return unless params[:limit].to_i.positive?
          @filters[:limit] = params[:limit].to_i
          @markers = @markers.limit(params[:limit].to_i)
        end

        def type_filter
          return unless params[:type].present?
          @filters[:type] = params[:type]
          @markers = @markers.by_type(params[:type])
        end

        def marker_params
          params.require(:marker)
                .permit(:description,
                        :email,
                        :latitude,
                        :longitude,
                        :marker_type,
                        :name,
                        :phone,
                        :resolved)
                .tap do |marker|
                  marker[:categories] = params.dig(:marker, :categories).permit! if params.dig(:marker, :categories)
                  marker[:data] = params.dig(:marker, :data).permit! if params.dig(:marker, :data)
                end
        end
      end
    end
  end
end
