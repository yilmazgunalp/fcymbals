class Thedrum < Shop


@merchant = "thedrum"
@shop = Scraper.merchants[@merchant]	
@page = Scraper.agent.get shop['url']


@options = {

}

def self.scrape 
prepare_file
extract_data(page)
@file.flush.close
@file.to_io
end #scrape()



end #class Thedrum	