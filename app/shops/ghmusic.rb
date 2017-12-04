class Ghmusic < Shop


@merchant = "ghmusic"
@shop = Scraper.merchants[merchant]	
@page = Scraper.agent.get shop['url']

@options = {

}


def self.scrape
prepare_file 
extract_data(page)
@file.flush.close
@file.to_io
end #scrape()


def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end # extract_data

def self.prepare_file 
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w") 
@file = CSV.open(new_file,'a+',:quote_char => '\'')	
file <<  ["title","price","s_price","picture_url","merchant","link"]
end	# prepare file

end # class Ghmusic