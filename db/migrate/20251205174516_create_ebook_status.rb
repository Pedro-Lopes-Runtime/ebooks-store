class CreateEbookStatus < ActiveRecord::Migration[8.1]
  def change
    create_table :ebook_statuses do |t|
      t.string :name
      t.timestamps
    end

    add_reference :ebooks, :ebook_status
  end
end
