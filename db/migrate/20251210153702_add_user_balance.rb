class AddUserBalance < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :balance, :float, default: 0
  end
end
