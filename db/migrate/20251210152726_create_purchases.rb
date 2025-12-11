class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.belongs_to :buyer
      t.belongs_to :ebook
      t.float :price, default: 0

      t.timestamps
    end
  end
end
