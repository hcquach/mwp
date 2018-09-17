class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :batch
      t.text :description
      t.string :city
      t.string :image
      t.string :site
      t.integer :year
      t.boolean :online
      t.integer :votes

      t.timestamps
    end
  end
end
