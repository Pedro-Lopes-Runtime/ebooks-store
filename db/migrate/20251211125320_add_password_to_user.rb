class AddPasswordToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_digest, :string, null: false

    add_index :users, :email, unique: true
  end
end
