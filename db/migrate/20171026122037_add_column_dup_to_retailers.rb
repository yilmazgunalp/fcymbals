class AddColumnDupToRetailers < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :dup, :integer, default: 'null'
  end
end
