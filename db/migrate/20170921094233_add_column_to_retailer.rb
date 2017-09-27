class AddColumnToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :merchant, :string
  end
end
