require 'test_helper'

class Api::NeedsControllerTest < ActionDispatch::IntegrationTest

  test "Using If-Modified-Since will 304" do
    max = Need.maximum("updated_at")
    get "/api/v1/needs", headers: {
      "If-Modified-Since" => max.rfc2822
    }
    assert_equal 304, response.status
  end

  test "returns all needs" do
    count = Need.count
    get "/api/v1/needs"
    json = JSON.parse(response.body)
    assert_equal count, json["needs"].length
    assert_equal count, json["meta"]["result_count"]
  end

  test "Geo and limits work" do
    get "/api/v1/needs?lat=30.0071377&lon=-95.3797033&limit=1"
    json = JSON.parse(response.body)
    assert_equal 1, json["needs"].length
    assert_equal 1, json["meta"]["result_count"]
  end

  test "filters are returned" do
    count = Need.where(are_supplies_needed: true).count
    get "/api/v1/needs?supplies_needed=true"
    json = JSON.parse(response.body)
    assert_equal count, json["needs"].length
    assert_equal count, json["meta"]["result_count"]
    assert_equal "true", json["meta"]["filters"]["supplies_needed"]
  end

  test "needs are not returned after they are archived" do
    archived = Need.where(active: false).count
    active = Need.where(active: !false).count
    count = active - archived
    get "/api/v1/needs"
    json = JSON.parse(response.body)
    assert_equal count, json["needs"].length
  end
end
