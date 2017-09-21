# frozen_string_literal: true

require 'test_helper'

class Api::V1::Connect::FlagsControllerTest < ActionDispatch::IntegrationTest

  def default_headers(headers = nil)
    headers || { "DisasterConnect-Device-UUID": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" }
  end

  test "can flag a marker for inapproiate content" do
    marker = connect_markers(:offensive)
    assert_difference('Connect::Marker.flagged.count', 1) do
      post api_v1_connect_marker_flag_path(marker),
        params: { marker_id: marker.id, reason: 'This guy is being a jerk.' },
        headers: default_headers
    end
    assert_response 204
    marker.reload
    assert_equal marker.data.dig('inappropriate_flag', 'flagged_for'), 'This guy is being a jerk.'
    assert_equal marker.data.dig('inappropriate_flag', 'flagged_by'), "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  end

  test "can not flag a marker without a device uuid" do
    marker = connect_markers(:offensive)
    post api_v1_connect_marker_flag_path(marker),
      params: { marker_id: marker.id, reason: 'This guy is being a jerk.' },
      headers: default_headers({})
    assert_response 403
  end
end
