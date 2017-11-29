class Kosmic < Shop


@merchant = "kosmic"
@shop = Scraper.merchants[@merchant]	
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w")
@file = CSV.open(new_file,'a+',:quote_char => '\'')

@options = {

}

file <<  ["title","price","s_price","picture_url","merchant","link","description"]

def self.scrape 
puts "inside kosmic scrape now"	
param = 1 	
page = get_page(shop['url'],{"pgnum" => param})
p page
	while !page.at_css('div.thumb').nil?
	extract_data page
	param += 1
	page = get_page(shop['url'],{"pgnum" => param})
	end # while	
end #scrape()


def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end 

def self.get_page link, param
page = Scraper.agent.get link, param
end


end #class Kosmic	

