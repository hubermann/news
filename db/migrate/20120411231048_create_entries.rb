class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :description
      t.integer :mainimg
      t.integer :cat_id

      t.timestamps
    end
  end
end
