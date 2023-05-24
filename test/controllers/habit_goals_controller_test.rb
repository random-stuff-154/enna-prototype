require "test_helper"

class HabitGoalsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get habit_goals_new_url
    assert_response :success
  end

  test "should get create" do
    get habit_goals_create_url
    assert_response :success
  end
end
