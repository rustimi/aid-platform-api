class AddPublishDateToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :publish_date, :timestamp
  end
end
