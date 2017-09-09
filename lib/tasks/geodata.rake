# frozen_string_literal: true

namespace :shelter do
  desc 'Populate empty coordinates for shelter data'
  task backfill_geo_data: :environment do
    Shelter.where(latitude: nil, longitude: nil).each do |shelter|
      next if shelter.address.blank? || shelter.city.blank?

      lat, lng = Geocoder.coordinates("#{shelter.address}, #{shelter.city}")
      shelter.update_attributes(latitude: lat, longitude: lng)
    end
  end
end
