class ScrapeJob
include Scraper	

def self.queue
    :scrapeR
  end	

  def self.perform shop
    Scraper.get_data shop
    
  end
end