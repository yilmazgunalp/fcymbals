class Shop 

class << self 
attr_accessor :merchant,:shop,:file,:page,:form,:options
end	

def self.prepare_file 
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w") 
@file = CSV.open(new_file,'a+',:quote_char => '\'', :col_sep => '~')	
@file <<  ["title","price","s_price","picture_url","merchant","link"]
end	

def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end # extract_data

end