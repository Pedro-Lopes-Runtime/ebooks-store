class ChangeEbookStatusToAnEnum < ActiveRecord::Migration[8.1]
  def change
    remove_reference :ebooks, :ebook_status
    drop_table :ebook_statuses
    add_column :ebooks, :status, :integer, null: false, default: 0
  end
end
