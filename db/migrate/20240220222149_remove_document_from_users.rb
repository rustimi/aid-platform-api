class RemoveDocumentFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :document
  end
end
