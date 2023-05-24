class RenameLongTermGoalsToHabitGoals < ActiveRecord::Migration[6.0]
  def change
    rename_table :long_term_goals, :habit_goals
  end
end
