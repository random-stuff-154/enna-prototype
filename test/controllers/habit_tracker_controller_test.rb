require "test_helper"

class HabitTrackerControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get habit_tracker_show_url
    assert_response :success
  end
end
