class ScrapeJob
include Scraper	

def self.queue
    :scrapeR
  end	

  def self.perform shop
    Scraper.scrape shop
    
  end
end