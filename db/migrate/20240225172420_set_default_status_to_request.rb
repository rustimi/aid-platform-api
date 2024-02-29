class SetDefaultStatusToRequest < ActiveRecord::Migration[7.1]
  def change
    change_column :requests, :status, :string, default: 'unfulfilled'
    change_column :requests, :fulfillment_count, :integer, default: 0
  end
end
