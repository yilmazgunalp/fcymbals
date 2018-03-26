class AddColumnToMerchant < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :code, :string
  end
end
