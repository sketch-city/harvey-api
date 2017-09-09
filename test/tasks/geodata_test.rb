require 'rake'
require 'test_helper'

class GeoDataRakeTask < ActiveSupport::TestCase
  def add_stub(shelter, lat, lng)
    Geocoder::Lookup::Test.add_stub("#{shelter.address}, #{shelter.city}", [{
      'latitude' => lat,
      'longitude' => lng
    }])
  end

  test "when the geo data is missing it fills in missing geo data" do
    skip
    address = "1010 Waugh"
    city = "Houston"

    stubbed_lat = 29.7496888
    stubbed_lng = -95.4579427

    shelter = Shelter.create!(
      shelter: "Houston Area Women's Center",
      address: address,
      city: city
    )

    add_stub(shelter, stubbed_lat, stubbed_lng)

    assert(shelter.valid?)
    Rake::Task['shelter:backfill_geo_data'].invoke

    assert_equal(shelter.reload.latitude, stubbed_lat)
    assert_equal(shelter.reload.longitude, stubbed_lng)
  end

  test "when the geo data is not missing it does not change that record" do
    skip
    shelter = shelters(:nrg)
    shelter_2 = shelters(:lonestar)

    add_stub(shelter, rand, rand)
    add_stub(shelter_2, rand, rand)

    assert(shelter.reload.latitude)
    assert(shelter.reload.longitude)

    assert_no_difference ['shelter.updated_at', 'shelter.latitude', 'shelter.longitude'] do
      Rake::Task['shelter:backfill_geo_data'].invoke
    end
  end
end
