require 'test_helper'

class ShelterTest < ActiveSupport::TestCase

  test "the fixtures work" do
    assert_equal Shelter.count, 2
  end

  test 'geocodes on save' do
    shelter = Shelter.create(
      shelter: "Houston Area Women's Center",
      address: '1010 Waugh',
      city: 'Houston'
    )

    assert_not_nil shelter.latitude
    assert_not_nil shelter.longitude
  end
end
