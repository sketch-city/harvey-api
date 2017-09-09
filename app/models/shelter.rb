class Shelter < ApplicationRecord
  ColumnNames = ["id", "accepting", "address", "address_name", "city", "county", "notes", "pets", "phone", "shelter", "source", "supply_needs", "updated_by", "volunteer_needs", "distribution_center", "food_pantry", "updated_at", "latitude", "longitude"]

  HeaderNames = ColumnNames.map(&:titleize)

  UpdateFields = ["accepting", "address", "address_name", "city", "county", "notes", "pets", "phone", "shelter", "source", "supply_needs", "updated_by", "volunteer_needs", "distribution_center", "food_pantry", "latitude", "longitude"]

  PrivateFields = ["private_notes"]

  has_many :drafts, as: :record
  default_scope { where(active: !false) }

  geocoded_by :address
  after_validation :geocode, if: :should_geocode

  after_commit do
    ShelterUpdateNotifierJob.perform_later self
  end

  private

  def should_geocode
    (address.present? && city.present?) &&
      (address_changed? || city_changed?)
  end
end
