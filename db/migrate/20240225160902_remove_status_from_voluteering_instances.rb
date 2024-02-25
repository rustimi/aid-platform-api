class RemoveStatusFromVoluteeringInstances < ActiveRecord::Migration[7.1]
  def change
    remove_column :volunteering_instances, :status
  end
end
