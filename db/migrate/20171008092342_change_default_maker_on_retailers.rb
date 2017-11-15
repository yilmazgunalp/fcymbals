class ChangeDefaultMakerOnRetailers < ActiveRecord::Migration[5.0]
  def change
  	# change_column_default(:retailers, :maker_id, from: "null", to: Maker.find(604))
  end
end
