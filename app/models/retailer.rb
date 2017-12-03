class Retailer < ApplicationRecord
  belongs_to :maker, :inverse_of => :retailers

def self.csv_import file
items = []
	CSV.foreach(file, headers: true, :quote_char => '^') do |row|
	  r = Retailer.new(row.to_h)
	  r.maker = Maker.find(3604)
	  r.save!
	end
end	



end
