class AddTitleToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :title, :string
  end
end
