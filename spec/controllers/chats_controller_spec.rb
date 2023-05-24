require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:chat) { FactoryBot.create(:chat, user: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    subject { get :show, params: { id: chat.id } }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end

    it 'assigns @chat' do
      subject
      expect(assigns(:chat)).to eq(chat)
    end

    it 'assigns @message' do
      subject
      expect(assigns(:message)).to be_a_new(Message)
    end

    context 'when chat has no messages' do
      it 'creates a welcome message' do
        expect { subject }.to change { chat.messages.count }.by(1)
        expect(chat.messages.last.content).to be_in(controller.send(:welcome_message))
      end
    end

    context 'when chat has messages' do
      let!(:message) { FactoryBot.create(:message, chat: chat, user: user) }

      context 'and last message was created more than 3 hours ago' do
        before do
          message.update_column(:created_at, 4.hours.ago)
        end

        it 'creates a welcome message' do
          expect { subject }.to change { chat.messages.count }.by(1)
          expect(chat.messages.last.content).to be_in(controller.send(:welcome_message))
        end
      end

      context 'and last message was created less than 3 hours ago' do
        before do
          message.update_column(:created_at, 2.hours.ago)
        end

        it 'does not create a welcome message' do
          expect { subject }.not_to change { chat.messages.count }
        end
      end
    end

    context 'when params[:message] is present' do
      subject { get :show, params: { id: chat.id, message: 'Hello!' } }

      before do
        allow(controller).to receive(:get_chat_gpt_response).and_return('Hello, human!')
      end

      it 'creates a user message and a gpt response' do
        expect { subject }.to change { chat.messages.count }.by(2)
        expect(chat.messages[-2].content).to eq 'Hello!'
        expect(chat.messages[-2].prompt_or_response).to be true
        expect(chat.messages.last.content).to eq 'Hello, human!'
        expect(chat.messages.last.prompt_or_response).to be false
      end
    end
  end
end
