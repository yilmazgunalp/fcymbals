class Ghmusic < Shop


@merchant = "ghmusic"
@shop = Scraper::MERCHANTS[merchant]
@page = get_page(shop['url'])

@options = {

}


def self.scrape
prepare_file 
extract_data(page)
@file.flush.close
@file.to_io
end #scrape()

end # class Ghmusic