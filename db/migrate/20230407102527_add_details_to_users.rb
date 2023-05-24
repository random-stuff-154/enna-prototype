class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :anonymous_id, :integer
    add_column :users, :question_1_answer, :text
    add_column :users, :question_2_answer, :text
    add_column :users, :question_3_answer, :text
  end
end
