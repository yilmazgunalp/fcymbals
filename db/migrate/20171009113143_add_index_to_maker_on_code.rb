class AddIndexToMakerOnCode < ActiveRecord::Migration[5.0]
  def change
  	add_index :makers, :code
  end
end
