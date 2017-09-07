class AddDefaults < ActiveRecord::Migration[5.0]
  def change
  	change_column(:makers, :brand, :string, default: "no brand") 
  	change_column(:makers, :kind, :string, default: "no kind") 
  end
end
