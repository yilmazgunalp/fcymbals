class Newdefaultmaker < ActiveRecord::Migration[5.0]
  def change
  	change_column_default(:retailers, :maker_id,  to: 3604) 
  end
end
