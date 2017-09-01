require 'test_helper'

class ShelterTest < ActiveSupport::TestCase

  test "the fixtures work" do
    assert_equal Shelter.count, 2
  end

  test "shelter name is NOT nil" do
    shelters = Shelter.all
    shelters.each do |shelter|
      assert_not_equal shelter.shelter, nil
    end
  end

  test "shelter's longitude and latitude is a float type" do
    shelters = Shelter.all
    shelters.each do |shelter|
      assert_equal shelter.column_for_attribute('longitude').type, :float
      assert_equal shelter.column_for_attribute('latitude').type, :float
    end
  end

end
