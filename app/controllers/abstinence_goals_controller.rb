class AbstinenceGoalsController < ApplicationController
  include AbstinenceGoalsHelper
  before_bugsnag_notify :add_user_info_to_bugsnag
  before_bugsnag_notify :add_controller_action_to_bugsnag

  def new
    @abstinence_goal = AbstinenceGoal.new
  end

  def create
    begin
      AbstinenceGoal.transaction do
        @old_abstinence_goals = AbstinenceGoal.all
        @old_abstinence_goals.update_all(current_goal: false)

        @abstinence_goal = AbstinenceGoal.new(abstinence_goal_params)
        @abstinence_goal.user = current_user
        @abstinence_goal.current_goal = true
        @abstinence_goal.start_date = Date.today

        if @abstinence_goal.save
          @habit_goal = HabitGoal.find_by(user_id: current_user.id, current_goal: true)

          if @habit_goal
            @chat = Chat.find_by(user_id: current_user.id)
            if @chat
              redirect_to chat_path(@chat)
            else
              redirect_to root_path, notice: "Abstinence goal created successfully, but chat not found"
            end
          else
            redirect_to new_habit_goal_path, notice: "Abstinence goal created successfully, but no habit goal found"
          end
        else
          render :new, status: :unprocessable_entity
        end
      end
    rescue => exception
      Bugsnag.notify(exception)
      # Handle the exception as per your requirement
    end
  end


  def relapse(user_id, tracker_id)
    current_goal = AbstinenceGoal.where(user_id: user_id, current_goal: true).first
    if current_goal
      tracker = AbstinenceTracker.find(tracker_id)
      tracker_date = tracker.date

      # Calculate the end date of the goal
      goal_end_date = current_goal.start_date + current_goal.length.days

      # Check if tracker date falls within the goal period
      if tracker_date.between?(current_goal.start_date, goal_end_date)
        # Get all trackers in the goal period
        trackers_in_goal_period = AbstinenceTracker.where(user_id: user_id)
                                                  .where("date >= ? AND date <= ?", current_goal.start_date, goal_end_date)

        # If any of the trackers are marked as relapsed (abstained = false), set achieved to false
        if trackers_in_goal_period.where(abstained: false).any?
          current_goal.update(achieved: false)
        else
          current_goal.update(achieved: true)
        end

        render json: { status: 'success' }
      else
        render json: { status: 'success', message: 'The status change does not fall within the goal period' }
      end
    else
      render json: { status: 'failure', error: 'Current goal not found' }
    end
  end
  
  private

  def within_abstinence_goal?(date)
    current_abstinence_goal = AbstinenceGoal.find_by(user_id: current_user.id, current_goal: true)
    return false unless current_abstinence_goal

    start_date = current_abstinence_goal.start_date
    end_date = start_date + current_abstinence_goal.length.days

    date.between?(start_date, end_date)
  end

  def abstinence_goal_params
    params.require(:abstinence_goal).permit(:length)
  end

  def add_user_info_to_bugsnag(event)
    event.set_user(current_user.id.to_s, current_user.email)
  end

  def add_controller_action_to_bugsnag(event)
    event.add_metadata(:controller_action, {
      controller: self.class.name,
      action: action_name
    })
  end
end
