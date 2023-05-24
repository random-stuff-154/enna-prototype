module AbstinenceGoalsHelper
  def within_abstinence_goal?(date)
    current_abstinence_goal = AbstinenceGoal.find_by(user_id: current_user.id, current_goal: true)
    return false unless current_abstinence_goal

    start_date = current_abstinence_goal.start_date
    end_date = start_date + (current_abstinence_goal.length - 1).days

    date.between?(start_date, end_date)
  end
end
