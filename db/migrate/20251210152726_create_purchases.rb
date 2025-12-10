class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.belongs_to :buyer
      t.float :total_price

      t.timestamps
    end

    create_table :ebook_purchases do |t|
      t.belongs_to :purchase
      t.belongs_to :ebook
      t.float :price
    end
  end
end
