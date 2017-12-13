class Adddefstoretailer < ActiveRecord::Migration[5.0]
  def change
  	change_column_null :retailers, :merchant, false
  	change_column_null :retailers, :title, false
  	change_column_null :retailers, :price, false
  	change_column_null :retailers, :link, false
  end
end
