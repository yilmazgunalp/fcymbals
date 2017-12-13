class Thedrum < Shop

@merchant = "thedrum"
@shop = Scraper.merchants[@merchant]	
@page = get_page(shop['url'])


@options = {
price: lambda do |item,selector| 
			if item.at_css(Scraper.tags.dig(merchant,"poa"))
			return 0	
			else
			item.at_css(selector).text.gsub(/,/,"").match(/\d+/)[0].to_i
			end
		end				
}

def self.scrape 
prepare_file
extract_data(page)
@file.flush.close
@file.to_io
end #scrape()

end #class Thedrum	