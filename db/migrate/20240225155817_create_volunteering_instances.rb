class CreateVolunteeringInstances < ActiveRecord::Migration[7.1]
  def change
    create_table :volunteering_instances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
