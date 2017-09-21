# frozen_string_literal: true

module Connect
  class Marker < ApplicationRecord
    MARKER_TYPES = %w[have need].freeze

    validates :categories, :device_uuid, :name, :phone, presence: true
    validates :marker_type, inclusion: { in: MARKER_TYPES, allow_blank: false }
    validates :latitude, :longitude, numericality: { other_than: 0 }
    validates :email, format: { with: /\A.+@.+\z/, allow_nil: true }

    reverse_geocoded_by :latitude, :longitude
    after_validation :reverse_geocode, if: :coordinates_changed?

    scope :by_category, ->(category) { where('categories ? :category', category: category) }
    scope :by_device_uuid, ->(device_uuid) { where(device_uuid: device_uuid) }
    scope :by_type, ->(type) { where(marker_type: type) }
    scope :flagged, ->() { where("data ? 'inappropriate_flag'") }
    scope :not_flagged, ->() { where.not("data ? 'inappropriate_flag'") }
    scope :resolved, -> { where(resolved: true) }
    scope :unresolved, -> { where(resolved: false) }

    def coordinates_changed?
      return false if latitude.zero? || longitude.zero?
      latitude_changed? || longitude_changed?
    end

    def flagged_inappropriate?
      data.key? 'inappropriate_flag'
    end

    def flag_as_inappropriate!(device_uuid:, reason:)
      return if flagged_inappropriate?
      data['inappropriate_flag'] = {
        flagged_by: device_uuid,
        flagged_for: reason,
        flagged_at: Time.zone.now
      }
      save
    end

    def clear_inappropriate_flag!
      data.delete('inappropriate_flag')
      save!
    end

    def flagged_by
      data.dig 'inappropriate_flag', 'flagged_by'
    end

    def flagged_for
      data.dig 'inappropriate_flag', 'flagged_for'
    end

    def flagged_at
      data.dig 'inappropriate_flag', 'flagged_at'
    end
  end
end
