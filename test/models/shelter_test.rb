require 'test_helper'

class ShelterTest < ActiveSupport::TestCase

  test "the fixtures work" do
    assert_equal Shelter.count, 2
  end

  test "shelter name is NOT nil" do
    @shelters = Shelter.all
    @shelters.each do |s|
      assert_not_equal s.shelter, nil
    end
  end

end
