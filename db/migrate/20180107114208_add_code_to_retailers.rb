class AddCodeToRetailers < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :code, :string
  end
end
