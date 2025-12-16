class AddPasswordUpdatedAtToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_updated_at, :timestamp, null: false, default: DateTime.now
  end
end
