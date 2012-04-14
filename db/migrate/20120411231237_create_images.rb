class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :filename
      t.integer :entrie_id

      t.timestamps
    end
  end
end
