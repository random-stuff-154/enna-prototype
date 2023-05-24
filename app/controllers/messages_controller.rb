class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.user = current_user
    @message.prompt_or_response = true
    if @message.save
      response_content = make_api_request(@message.content)
      @response = Message.create(content: response_content, chat: @chat, user: current_user, prompt_or_response: false)
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def destroy
    @chat = Chat.find(params[:chat_id])
    @chat.messages.destroy_all
    redirect_to chat_path(@chat), notice: 'All messages for this chat have been deleted.'
  end

  def get_abstinence_progress(user_id)
    last_5_days_data = AbstinenceTracker.where(user_id: user_id)
                                      .where('date >= ?', Date.today - 5.days)
                                      .where.not(abstained: nil)
                                      .order(date: :desc)
                                      .pluck(:date, :abstained)

    progress_text = "For context, in the last 5 days this is my progress:\n"
    last_5_days_data.each do |date, abstained|
      progress_text += "#{date.strftime('%B %d')}: #{abstained ? 'abstained' : 'relapsed'}\n"
    end

    progress_text += "Yesterday: #{last_5_days_data[0][1] ? 'abstained' : 'n/a'}"

    progress_text
  end


  private

  def message_params
    params.require(:message).permit(:content)
  end

  def make_api_request(current_prompt)
    context_prompt = "As an AI psychotherapist and psychosocial occupational therapist within the 'enna' app, you specialize in addiction recovery. You're a British, calm, neutral, and supportive, acting as a sponsor while building rapport. Your goal is to foster mindset shifts through brief, thought-provoking questions, without giving explicit advice."
    
    user_abstinence_last_5_days_context = "#{get_abstinence_progress(current_user.id)}\n"
    
    typical_conversation = <<~CONVERSATION
      A typical conversation with a (not real, for example purposes) user:
      enna: Hey there, welcome back. How's it going?
      user: ok, not great. I'm watching less porn but still feel I should be doing better.
      enna: I'm sorry to hear that. What's stressing you out?
      user: i keep giving in to my urges, i find it difficult to not watch it
      enna: I see. Have you tried picking any new habits to distract you from your urges?
      user: i've started a positive new habit 
      enna: Nice one, that's a solid step. How did that make you feel emotionally?

      last 5 messages from the current user:
    CONVERSATION


    last_5_user_messages = Message.where(chat_id: params[:chat_id], user: current_user, prompt_or_response: true).last(5)
    user_messages_history = last_5_user_messages.map { |message| { role: 'user', content: message.content } }

    prompt = [
      { role: 'system', content: context_prompt + user_abstinence_last_5_days_context + "\n\n" + typical_conversation },
      *user_messages_history,
      { role: 'user', content: current_prompt }
    ]

    puts "------ prompt -------" + prompt.inspect

    openai = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = openai.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: prompt
      }
    )


    response_text = response.dig("choices", 0, "message", "content")
    puts "------ response -------" + response.inspect

    return response_text
  end

  def add_user_info_to_bugsnag(event)
    if current_user
      user_id = current_user.id.to_s
      user_email = current_user.email
      event.set_user(user_id, user_email, user_name)
    else
      event.set_user("Unknown", "Unknown", "Unknown")
    end
  end
end
