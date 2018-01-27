class Derringers < Shop


@merchant = "derringers"
@shop = Scraper::MERCHANTS[merchant]	

@options = {

}


def self.scrape 
prepare_file
param = 1 	
page = get_page(shop['url'],{"p" => param})
	while !page.at_css('a.button.next.i-next').nil?
	extract_data page
	param += 1
	page = get_page(shop['url'],{"p" => param})
	end # while
# scrape the last page 
extract_data page
@file.flush.close
@file.to_io		
end #scrape()

end #class Derringers	
