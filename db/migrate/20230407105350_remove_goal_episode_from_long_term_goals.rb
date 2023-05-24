class RemoveGoalEpisodeFromLongTermGoals < ActiveRecord::Migration[6.0]
  def change
    remove_column :long_term_goals, :goal_episode, :text
  end
end
