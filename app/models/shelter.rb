class Shelter < ApplicationRecord
  ColumnNames = ["id", "accepting", "address", "address_name", "city", "county",
                 "state", "notes", "pets", "phone", "shelter", "source",
                 "supply_needs", "updated_by", "volunteer_needs",
                 "distribution_center", "food_pantry", "updated_at",
                 "latitude", "longitude"]

  HeaderNames = ColumnNames.map(&:titleize)

  UpdateFields = ["accepting", "address", "address_name", "city", "county",
                  "state", "notes", "pets", "phone", "shelter", "source",
                  "supply_needs", "updated_by", "volunteer_needs",
                  "distribution_center", "food_pantry", "latitude", "longitude"]

  PrivateFields = ["private_notes"]

  has_many :drafts, as: :record
  default_scope { where(active: !false) }

  geocoded_by :address

  after_commit do
    ShelterUpdateNotifierJob.perform_later self
  end

  before_save :calculate_values

  def calculate_values
    self.calculated_needs = (volunteer_needs || "").split(",") + (supply_needs || "").split(",")
    self.calculated_updated_at_rfc3339 = (updated_at || Time.now).in_time_zone("Central Time (US & Canada)").rfc3339
    stripped_phone = (phone||"").gsub(/\D/,"")
    self.calculated_phone = stripped_phone.match?(/^\d{10}$/) ? stripped_phone : "badphone"
  end
end
