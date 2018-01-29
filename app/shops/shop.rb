class Shop 

class << self 
attr_accessor :merchant,:shop,:file,:page,:form,:options
end	

def self.prepare_file 
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w") 
@file = CSV.open(new_file,'a+',:quote_char => '\'', :col_sep => '~')	
@file <<  ["title","price","s_price","picture_url","merchant","link","code"]
end	

def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end # extract_data

def self.get_page link, param = nil 
Scraper::AGENT.get link, param 
rescue Mechanize::Error,SocketError => e
Scraper::LOG_FILE << "[FATAL]:[#{self.to_s.upcase}]: Could not retrieve webpage at => #{link}
[ERROR]: #{e.class} [MESSAGE]: #{e.message}\n"
end # get_page


end