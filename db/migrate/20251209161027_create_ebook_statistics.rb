class CreateEbookStatistics < ActiveRecord::Migration[8.1]
  def change
    create_table :ebook_statistics do |t|
      t.integer :purchases, null: false, default: 0
      t.integer :preview_views, null: false, default: 0
      t.integer :visits, null: false, default: 0
      t.belongs_to :ebook

      t.timestamps
    end

    create_table :visitor_statistics do |t|
      t.string :ip
      t.string :browser
      t.string :location
      t.belongs_to :ebook_statistic

      t.timestamps
    end
  end
end
