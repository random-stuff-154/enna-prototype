class HabitTrackersController < ApplicationController
  def create
    begin
      @habit_tracker = HabitTracker.new(habit_tracker_params)
      @habit_tracker.user = current_user
      @habit_tracker.date = Date.today
      @habit_tracker.save
    rescue => exception
      Bugsnag.notify(exception)
      # Handle the exception as per your requirement
    end
  end

  def index
    @user_habit_goals = HabitGoal.where(user_id: current_user.id)
    @current_habit_goal = @user_habit_goals.find_by(current_goal: true)

    @user_habit_trackings = HabitTracker.where(user_id: current_user.id)

    if @current_habit_goal && @current_habit_goal.length
      @current_habit_goal_days_passed = (Date.today - @current_habit_goal.start_date.to_date).to_i
      @current_habit_goal_length = @current_habit_goal.length

      @current_habit_goal_successful_days = @user_habit_trackings.count { |n| n.habit_achieved == true && n.date >= @current_habit_goal.start_date }

      @progress = ((@current_habit_goal_successful_days.to_f * 100) / @current_habit_goal_length).round(2)
      @progress_percentage = ((@current_habit_goal_successful_days.to_f * 100) / @current_habit_goal_length).round(2)
    end
  end

  def edit
    if params[:id].match?(/\A\d{4}-\d{2}-\d{2}\z/)
      date = Date.parse(params[:id])
    else
      date = Date.today
    end
    @habit_tracker = HabitTracker.find_or_create_by(user: current_user, date: date)
  end

  def update
    @habit_tracker = HabitTracker.find(params[:id])

    begin
      if @habit_tracker.update(habit_tracker_params)
        respond_to do |format|
          format.html { redirect_to @habit_tracker }
          format.js   # This will render the corresponding JavaScript file
          format.json { render json: @habit_tracker }
        end
      else
        render :edit
      end
    rescue => exception
      Bugsnag.notify(exception)
      # Handle the exception as per your requirement
    end
  end

  def calendar_data
    user_trackers = current_user.habit_trackers
    calendar_data = {}
    user_trackers.each do |tracker|
      calendar_data[tracker.date] = tracker.habit_achieved ? 'green' : 'red'
    end
    render json: calendar_data
  end

  private

  def habit_tracker_params
    params.require(:habit_tracker).permit(:habit_achieved, :date)
  end
end
