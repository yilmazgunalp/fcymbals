class Thedrum < Shop


@merchant = "thedrum"
@shop = Scraper.merchants[@merchant]	
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w")
@file = CSV.open(new_file,'a+',:quote_char => '\'')

@page = Scraper.agent.get shop['url']


@options = {

}

file <<  ["title","price","s_price","picture_url","merchant","link","description"]

def self.scrape 
extract_data(page)
end #scrape()


def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end # extract_data


end #class Thedrum	