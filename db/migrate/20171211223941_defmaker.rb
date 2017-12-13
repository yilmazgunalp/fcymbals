class Defmaker < ActiveRecord::Migration[5.0]
  def change
  	change_column(:retailers, :maker_id, :integer, default: 3604) 
  end
end
