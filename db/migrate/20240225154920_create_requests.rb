class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.text :description
      t.string :type
      t.string :status
      t.float :latitude
      t.float :longitude
      t.integer :requester_id
      t.integer :fulfillment_count

      t.timestamps
    end
  end
end
