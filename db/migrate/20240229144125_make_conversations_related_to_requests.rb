class MakeConversationsRelatedToRequests < ActiveRecord::Migration[7.1]
  def change
    remove_column :conversations, :receiver_id
    add_reference :conversations, :request, foreign_key: true
  end
end
