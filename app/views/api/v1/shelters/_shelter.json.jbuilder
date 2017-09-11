json.extract! shelter, :county, :shelter, :address, :city, :pets,
  :phone, :accepting, :updated_by, :notes,
  :volunteer_needs, :longitude, :latitude, :supply_needs, :source

json.needs shelter.calculated_needs

json.updated_at shelter.calculated_updated_at_rfc3339
json.updatedAt shelter.calculated_updated_at_rfc3339
json.last_updated shelter.calculated_updated_at_rfc3339
json.cleanPhone shelter.calculated_phone
