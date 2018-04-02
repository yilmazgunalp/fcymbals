class AddIndexToMerchant < ActiveRecord::Migration[5.2]
  def change
    add_index :merchants, :code
  end
end
