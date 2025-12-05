class CreateEbooksAndAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name

      t.timestamps
    end

    create_table :ebooks do |t|
      t.string :title
      t.text :description
      t.belongs_to :author

      t.timestamps
    end
  end
end
