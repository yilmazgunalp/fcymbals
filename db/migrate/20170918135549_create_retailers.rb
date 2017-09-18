class CreateRetailers < ActiveRecord::Migration[5.0]
  def change
    create_table :retailers do |t|
      t.references :maker, foreign_key: true, index:true
      t.string :title
      t.float :price
      t.float :s_price
      t.boolean :in_stock
      t.text	:description
      t.string	:picture_url
    
      t.timestamps
    end

  end
end
