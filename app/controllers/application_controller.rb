class ApplicationController < ActionController::Base
  before_bugsnag_notify :add_user_info_to_bugsnag

  def after_sign_in_path_for(resource)
    begin
      @user = User.find(current_user.id)

      # Direct user to answer the onboarding questions if they haven't yet done so
      if @user.question_1_answer.nil? || @user.question_2_answer.nil? || @user.question_3_answer.nil?
        return edit_user_path(current_user.id)
      end

      # Direct user to set a new abstinence goal if they haven't already
      @abstinence_goals = AbstinenceGoal.where(user_id: current_user.id)
      if @abstinence_goals.blank?
        return new_abstinence_goal_path
      end

      # Direct user to create a new habit goal if they haven't already
      @habit_goals = HabitGoal.where(user_id: current_user.id)
      if @habit_goals.blank?
        return habit_goals_path
      end

      # Direct user to the chat page if they have an existing goal that is a current goal and have created habit goals
      @abstinence_goals_current = @abstinence_goals.where(current_goal: true).exists?
      @habit_goals_current = @habit_goals.where(current_goal: true).exists?

      if @abstinence_goals_current && @habit_goals_current
        @chat = Chat.find_by(user_id: current_user.id)
        if @chat
          return chat_path(@chat)
        end
      end

      # Default to root_path if no other conditions are met
      root_path

    rescue => exception
      Bugsnag.notify(exception)
      root_path
    end
  end

  private

  def add_user_info_to_bugsnag(event)
    if current_user
      event.set_user(current_user.id.to_s, current_user.email)
    else
      event.set_user("Unknown", "Unknown")
    end
  end
end
