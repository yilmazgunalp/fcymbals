class Retailer < ApplicationRecord
  belongs_to :maker, :inverse_of => :retailers

def self.csv_import file
log_file = File.new("#{Rails.root}/log/Retailer_Update_log.txt","a+")

	CSV.foreach(file, headers: true, :quote_char => '\'',:col_sep => '~') do |row|
		begin 

		retailer =  check_for_retailer(row.field('title'), row.field('link'))
			if retailer 
			retailer.check_price(row.field('price').to_i)
			else	
			Retailer.create!(row.to_h)
			end #if retailer
		
		rescue  StandardError => e
		b = binding
		log_file << "[#{File.basename(file,'.csv').upcase}]: [UPDATE]: ROW IN ERROR =>\n"	
		log_file <<  b.eval("row") 
		log_file << "[ERROR MESSAGE]: #{e.message}\n\n"
		end # rescue	
	end # CSV.foreach
log_file.flush.close
end #csv_import	



def check_price new_price
new_price != price ? price = new_price : touch
end


def self.deactivate_records merchant,time
Retailer.where("merchant = ? AND updated_at < ?",merchant,time).each {|retailer| retailer.update(active: false)}
end	# deactivate_records



private

def self.check_for_retailer title,link
result = Retailer.where(title: title, link: link)
result.length == 1 ? result.first : false
end	# check_for_retailer


end # Retailer
