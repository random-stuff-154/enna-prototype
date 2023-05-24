require "test_helper"

class ChatbotConversationHistoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chatbot_conversation_history_index_url
    assert_response :success
  end

  test "should get show" do
    get chatbot_conversation_history_show_url
    assert_response :success
  end

  test "should get create" do
    get chatbot_conversation_history_create_url
    assert_response :success
  end
end
