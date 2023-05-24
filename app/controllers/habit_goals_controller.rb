class HabitGoalsController < ApplicationController
  before_bugsnag_notify :add_user_info_to_bugsnag

  def new
    @habit_goal = HabitGoal.new
  end

  def create
    begin
      @old_habit_goals = HabitGoal.all
      @old_habit_goals.each do |goal|
        goal.current_goal = false
        goal.save
      end

      @habit_goal = HabitGoal.new(habit_goal_params)
      @habit_goal.user = current_user
      @habit_goal.current_goal = true
      @habit_goal.start_date = Date.today

      if @habit_goal.save
        @chat = Chat.find_by(user_id: current_user.id)
        if @chat
          redirect_to chat_path(@chat)
        else
          Bugsnag.notify(RuntimeError.new('Chat not found'))
          redirect_to root_path, notice: "Abstinence goal created successfully, but chat not found"
        end
      else
        Bugsnag.notify($!)  # Report the exception
        render :new, status: :unprocessable_entity
      end
    rescue => e
      Bugsnag.notify(e)
      # Handle the exception as per your requirement
    end
  end

  private

  def habit_goal_params
    params.require(:habit_goal).permit(:input_text, :length, :threshold)
  end

  def add_user_info_to_bugsnag(notification)
    # Add custom user information
    notification.user = {
      id: current_user.id,
      email: current_user.email
    }
  end
end
