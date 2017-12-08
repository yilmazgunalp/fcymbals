class Retailer < ApplicationRecord
  belongs_to :maker, :inverse_of => :retailers

def self.csv_import file
log_file = File.new("#{Rails.root}/log/Retailer_Update_log.txt","a+")
items = []
	CSV.foreach(file, headers: true, :quote_char => '\'',:col_sep => '~') do |row|
	begin	
	  r = Retailer.new(row.to_h)
	  r.maker = Maker.find(3604)
	  r.save!
	rescue => e 
	b = binding
log_file << "[#{File.basename(file,'.csv').upcase}]: [Update Error]: ROW IN ERROR =>\n"	
log_file <<  b.eval("row") 
log_file << "[ERROR MESSAGE]: #{e.message}\n\n"	
	end # begin 
	end # CSV.foreach
log_file.flush.close
end #csv_import	



end
