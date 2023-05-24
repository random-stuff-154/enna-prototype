require "test_helper"

class ChatbotHistoryConversationControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get chatbot_history_conversation_show_url
    assert_response :success
  end

  test "should get index" do
    get chatbot_history_conversation_index_url
    assert_response :success
  end

  test "should get new" do
    get chatbot_history_conversation_new_url
    assert_response :success
  end

  test "should get create" do
    get chatbot_history_conversation_create_url
    assert_response :success
  end
end
