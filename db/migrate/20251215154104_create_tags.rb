class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :ebooks_tags, id: false do |t|
      t.belongs_to :ebook
      t.belongs_to :tag
    end
  end
end
