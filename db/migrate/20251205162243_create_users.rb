class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :displayname
      t.string :email
      t.boolean :status
      t.belongs_to :profileable, polymorphic: true

      t.timestamps
    end

    create_table :sellers do |t|
    end

    create_table :buyers do |t|
    end
  end
end
