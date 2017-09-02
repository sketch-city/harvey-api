require 'test_helper'

class Api::HooksControllerTest < ActionDispatch::IntegrationTest
  include ::ActiveJob::TestHelper

  test "ping triggers refresh" do

    assert_no_enqueued_jobs do
      post "/api/v1/google-sheet-update"
    end

    assert_no_enqueued_jobs do
      post "/api/v1/google-sheet-update"
    end
  end

end
