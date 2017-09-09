json.extract! location, *@location_class.table_columns

json.show_url location_url(organization: location.organization, legacy_table_name: location.legacy_table_name, id: location.id)
json.edit_url edit_location_url(organization: location.organization, legacy_table_name: location.legacy_table_name, id: location.id)
json.updatedAt location.updated_at
json.latitude location.latitude
json.longitude location.longitude
