class CreateLongTermGoal < ActiveRecord::Migration[6.0]
  def change
    create_table :long_term_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :current_goal
      t.text :input_text
      t.datetime :start_date
      t.integer :length
      t.float :threshold
      t.text :goal_episode
      t.boolean :achieved

      t.timestamps
    end
  end
end
