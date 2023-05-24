class CreateHabitTracker < ActiveRecord::Migration[6.0]
  def change
    create_table :habit_trackers do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :date
      t.boolean :habit_achieved

      t.timestamps
    end
  end
end
