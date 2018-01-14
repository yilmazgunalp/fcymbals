class RenameColoumnInRetailers < ActiveRecord::Migration[5.0]
  def change
  	rename_column :retailers, :dup, :duplicate
  end
end
