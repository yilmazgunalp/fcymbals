class AddColumnToRetailers < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :link, :string
  end
end
