class AbstinenceTrackersController < ApplicationController
  include AbstinenceGoalsHelper

  before_bugsnag_notify :add_user_info_to_bugsnag

  def create
    begin
      @abstinence_tracker = AbstinenceTracker.new(abstinence_tracker_params)
      @abstinence_tracker.user = current_user
      @abstinence_tracker.date = Date.today
      @abstinence_tracker.save
    rescue => exception
      Bugsnag.notify(exception)
      # Handle the exception as per your requirement
    end
  end

  def index
    @user_abstinence_goals = AbstinenceGoal.where(user_id: current_user.id)
    @current_abstinence_goal = @user_abstinence_goals.find_by(current_goal: true)

    @user_abstinence_trackings = AbstinenceTracker.where(user_id: current_user.id)

    if @current_abstinence_goal && @current_abstinence_goal.length
      @current_abstinence_goal_days_passed = (Date.today - @current_abstinence_goal.start_date.to_date).to_i
      @current_abstinence_goal_length = @current_abstinence_goal.length

      @current_abstinence_goal_successful_days = @user_abstinence_trackings.count { |n| n.abstained == true && n.date >= @current_abstinence_goal.start_date }

      @progress = (@current_abstinence_goal_successful_days.to_f * 100) / @current_abstinence_goal_length
      @progress_percentage = ((@current_abstinence_goal_successful_days.to_f * 100) / @current_abstinence_goal_length).round(2)
    end
  end

  def edit
    if params[:id].match?(/\A\d{4}-\d{2}-\d{2}\z/)
      date = Date.parse(params[:id])
    else
      date = Date.today
    end
    @abstinence_tracker = AbstinenceTracker.find_or_create_by(user: current_user, date: date)
  end

  def update
    @abstinence_tracker = AbstinenceTracker.find(params[:id])

    begin
      if @abstinence_tracker.update(abstinence_tracker_params)
        # After successfully updating the tracker, call the `relapse` method of `AbstinenceGoalsController`
        AbstinenceGoalsController.new.relapse(current_user.id, @abstinence_tracker.id)

        respond_to do |format|
          format.html { redirect_to @abstinence_tracker }
          format.js   # This will render the corresponding JavaScript file
          format.json { render json: @abstinence_tracker }
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
    user_trackers = current_user.abstinence_trackers
    calendar_data = {}
    user_trackers.each do |tracker|
      calendar_data[tracker.date] = tracker.abstained ? 'green' : 'red'
    end
    render json: calendar_data
  end

  private


  def abstinence_tracker_params
    params.require(:abstinence_tracker).permit(:abstained, :date)
  end



  def add_user_info_to_bugsnag(event)
    event.set_user(current_user.id.to_s, current_user.email)
  end
end




