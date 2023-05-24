require 'openai'

class ChatsController < ApplicationController
  before_bugsnag_notify :add_user_info_to_bugsnag

  def show
    begin
      @chat = Chat.find(params[:id])
      @message = Message.new

      # Check if the chat has any messages
      if @chat.messages.empty?
        # If not, create a new message with the welcome text
        create_message(welcome_message, false)
      else
        # Otherwise, use the most recent message as the message object
        @last_message = @chat.messages.last

        # Check the time elapsed since the last message was created
        time_since_last_message = Time.now - @last_message.created_at

        if time_since_last_message > 3.hours
          # If more than 3 hours have elapsed, create a new message with the welcome text
          create_message(welcome_message, false)
        end
      end

      # Check if there is a custom message from the query parameter
      if params[:message].present?
        user_message = create_message("#{params[:message]}", true)
        chat_gpt_response = get_chat_gpt_response(user_message.content, params[:chat_id])
        create_message(chat_gpt_response, false)
      end

    rescue => exception
      Bugsnag.notify(exception)
      redirect_to root_path, alert: "An error occurred while processing your request. Please try again later."
    end
  end

  private

  def create_message(content, prompt_or_response)
    @chat.messages.create(content: content, user_id: current_user.id, prompt_or_response: prompt_or_response)
  end 

  def welcome_message
    message_array = [
      "Hi there, welcome back to our session",
      "Hello, it's great to see you again",
      "Hey, I'm glad you're here. Let's dive in",
      "Welcome back! How was your week?",
      "Good to have you here. How can I support you today?",
      "Thanks for joining me again. How are things going?",
      "Hey, it's great to meet with you. What can we work on today?",
      "Hello, welcome to our conversation. How can I assist you?",
      "Good to see you again. What would you like to talk about?",
      "Welcome back! How have you been since our last meeting?"
    ]
    message_array[rand(10)]
  end

  def get_chat_gpt_response(prompt, chat_id)
    begin
      # Call the ApiRequestHelper module to make the API request
      response_content = ApiRequestHelper.make_api_request(prompt, chat_id)
      return response_content
    rescue => exception
      Bugsnag.notify(exception)
      # Handle the exception as per your requirement
    end
  end

  def add_user_info_to_bugsnag(event)
    if current_user
      event.set_user(current_user.id.to_s, current_user.email)
    else
      event.set_user("Unknown", "Unknown")
    end
  end
end
