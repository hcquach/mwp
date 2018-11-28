class CreateDailies < ActiveRecord::Migration[5.2]
  def change
    create_table :dailies do |t|

      t.timestamps
    end
  end
end
