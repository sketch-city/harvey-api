require 'test_helper'

class FlaggedMarkersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  fixtures :all

  test "only admins can access index" do
    get connect_flagged_markers_path
    assert_redirected_to root_path
    sign_in users(:admin)
    get connect_flagged_markers_path
    assert_response :success
  end

  test "only admins can access show" do
    get connect_flagged_marker_path(connect_markers(:flagged))
    assert_redirected_to root_path
    sign_in users(:admin)
    get connect_flagged_marker_path(connect_markers(:flagged))
    assert_response :success
  end

  test "Can clear a marker" do
    sign_in users(:admin)
    marker = connect_markers(:flagged)
    assert(marker.flagged_inappropriate?)
    delete connect_flagged_marker_path(marker)
    assert_redirected_to connect_flagged_markers_path
    marker.reload
    refute(marker.flagged_inappropriate?)
  end

  test "Can confirm a marker" do
    sign_in users(:admin)
    marker = connect_markers(:flagged)
    assert(marker.flagged_inappropriate?)
    refute(marker.resolved?)
    patch connect_flagged_marker_path(marker)
    assert_redirected_to connect_flagged_markers_path
    marker.reload
    assert(marker.flagged_inappropriate?)
    assert(marker.resolved?)
  end
end
