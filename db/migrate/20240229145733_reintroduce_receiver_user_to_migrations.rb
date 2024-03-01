class ReintroduceReceiverUserToMigrations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :receiver_id, :integer
    add_index :conversations, :receiver_id
    add_foreign_key :conversations, :users, column: :receiver_id
  end
end
