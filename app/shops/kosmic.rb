class Kosmic < Shop


@merchant = "kosmic"
@shop = Scraper.merchants[@merchant]	

@options = {

}


def self.scrape 
prepare_file
param = 1 	
page = get_page(shop['url'],{"pgnum" => param})

	while !page.at_css('div.thumb').nil?
	extract_data page
	param += 1
	page = get_page(shop['url'],{"pgnum" => param})
	end # while	
@file.flush.close
@file.to_io	
end #scrape()

end #class Kosmic	

