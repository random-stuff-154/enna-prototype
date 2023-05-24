require "test_helper"

class AbstinenceTrackersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get abstinence_trackers_show_url
    assert_response :success
  end
end
