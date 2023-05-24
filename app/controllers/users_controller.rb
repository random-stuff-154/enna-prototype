class UsersController < ApplicationController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    begin
      if @user.update(user_answers_params)
        # Check if the user has any abstinence goals
        @abstinence_goals = AbstinenceGoal.all.where(user_id: current_user.id)

        if @abstinence_goals.blank?
          # If the user has no abstinence goals, redirect them to create a new abstinence goal
          redirect_to new_abstinence_goal_path
        else
          # If the user has an abstinence goal, find their chat and redirect them to the chatbot page
          @chat = Chat.find_by(user_id: current_user.id)
          if @chat
            redirect_to chat_path(@chat)
          else
            redirect_to root_path, notice: "User questions updated successfully, but chat not found"
          end
        end
      else
        render :edit
      end
    rescue => exception
      Bugsnag.notify(exception)
      redirect_to root_path, alert: "An error occurred while updating user questions. Please try again later."
    end
  end

  def user_answers_params
    params.require(:user).permit(:question_1_answer, :question_2_answer, :question_3_answer)
  end
end
