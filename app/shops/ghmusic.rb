class Ghmusic < Shop


@merchant = "ghmusic"
@shop = Scraper.merchants[merchant]	
@new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w")
@file = CSV.open(@new_file,'a+',:quote_char => '\'')

@page = Scraper.agent.get shop['url']

@file <<  ["title","price","s_price","picture_url","merchant","link","description"]


@options = {

}


def self.scrape 
extract_data(page)
end #scrape()


def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end # extract_data

end # class Ghmusic