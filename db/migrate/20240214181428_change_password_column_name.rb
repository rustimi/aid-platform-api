class ChangePasswordColumnName < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password
    add_column :users, :password_digest, :string
    add_column :users, :password_confirmation, :string
  end
end
