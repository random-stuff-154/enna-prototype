class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :abstinence_trackers, dependent: :destroy
  has_many :habit_trackers, dependent: :destroy
  has_one :chat, dependent: :destroy
  after_create :add_chat
  has_one :habit_goal

  private

  def add_chat
    Chat.create!(user_id: self.id)
  end
end
