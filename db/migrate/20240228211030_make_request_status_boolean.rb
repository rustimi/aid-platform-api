class MakeRequestStatusBoolean < ActiveRecord::Migration[7.1]
  def change
    remove_column :requests, :status
    add_column :requests, :fulfilled, :boolean, default: false
  end
end
