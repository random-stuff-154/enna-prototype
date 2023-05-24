class RenameShortTermGoalsToAbstinenceGoals < ActiveRecord::Migration[6.0]
  def change
    rename_table :short_term_goals, :abstinence_goals
  end
end
