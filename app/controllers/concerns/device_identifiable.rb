module DeviceIdentifiable
  extend ActiveSupport::Concern

  included do
    before_action :check_device_uuid, only: [:create, :update]
  end

  private

  def device_uuid
    request.headers['HTTP_DISASTERCONNECT_DEVICE_UUID']
  end

  def missing_device_uuid
    render(json: { device_uuid: ['Must be set with DisasterConnect-Device-UUID header'] }, status: :forbidden)
  end

  def check_device_uuid
    missing_device_uuid if device_uuid.blank?
  end
end