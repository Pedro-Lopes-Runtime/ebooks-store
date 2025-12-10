class AddPriceToEbook < ActiveRecord::Migration[8.1]
  def change
    add_column :ebooks, :price, :float

    add_reference :ebooks, :seller
  end
end
