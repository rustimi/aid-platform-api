class RenameTypeInRequest < ActiveRecord::Migration[7.1]
  def change
    remove_column :requests, :type
    add_column :requests, :request_type, :string
  end
end
