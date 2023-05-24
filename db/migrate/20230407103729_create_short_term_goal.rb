class CreateShortTermGoal < ActiveRecord::Migration[6.0]
  def change
    create_table :short_term_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :current_goal
      t.datetime :start_date
      t.integer :length
      t.boolean :achieved

      t.timestamps
    end
  end
end
