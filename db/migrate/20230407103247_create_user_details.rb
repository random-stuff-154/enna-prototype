class CreateUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_details do |t|
      t.references :user, null: false, foreign_key: true
      t.text :email
      t.text :gender
      t.integer :age
      t.text :username

      t.timestamps
    end
  end
end
