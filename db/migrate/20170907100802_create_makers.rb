class CreateMakers < ActiveRecord::Migration[5.0]
  def change
    create_table :makers do |t|
    t.string :brand, :null => false
    t.string :code
    t.string :series
    t.string :model
    t.string :kind, :null => false
    t.string :size
    t.text :description	

      t.timestamps
    end
  end
end
