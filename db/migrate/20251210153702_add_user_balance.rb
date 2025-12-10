class AddUserBalance < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :balance, :float
  end
end
