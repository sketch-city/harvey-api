json.extract! need, :updated_by, :location_name,
  :location_address , :longitude , :latitude , :contact_for_this_location_name,
  :contact_for_this_location_phone_number , :are_volunteers_needed,
  :tell_us_about_the_volunteer_needs , :are_supplies_needed,
  :tell_us_about_the_supply_needs , :anything_else_you_would_like_to_tell_us
  :source

json.needs need.calculated_needs

json.updated_at need.calculated_updated_at_rfc3339
json.updatedAt need.calculated_updated_at_rfc3339
json.last_updated need.calculated_updated_at_rfc3339
json.cleanPhone need.calculated_phone
