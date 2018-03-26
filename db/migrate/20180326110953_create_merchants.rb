class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :state
      t.string :website

      t.timestamps
    end
  end
end
