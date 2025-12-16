class ChangeUserTypeToAnEnum < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :profileable_type
    remove_column :users, :profileable_id
    add_column :users, :user_type, :integer, null: false, default: 0

    drop_table :sellers
    remove_reference :ebooks, :seller
    add_reference :ebooks, :user

    drop_table :buyers
    remove_reference :purchases, :buyer
    add_reference :purchases, :user
  end
end
