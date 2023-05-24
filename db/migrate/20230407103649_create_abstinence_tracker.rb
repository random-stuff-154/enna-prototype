class CreateAbstinenceTracker < ActiveRecord::Migration[6.0]
  def change
    create_table :abstinence_trackers do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :date
      t.boolean :abstained

      t.timestamps
    end
  end
end
