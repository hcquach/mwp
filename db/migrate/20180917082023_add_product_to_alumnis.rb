class AddProductToAlumnis < ActiveRecord::Migration[5.2]
  def change
    add_reference :alumnis, :product, foreign_key: true
  end
end
