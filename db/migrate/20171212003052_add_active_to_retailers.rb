class AddActiveToRetailers < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :active, :boolean, default: true
  end
end
