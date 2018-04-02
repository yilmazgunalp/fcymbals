class Changemerchantcolumnname < ActiveRecord::Migration[5.2]
  def change
  	rename_column :retailers, :merchant, :shop
  end
end
