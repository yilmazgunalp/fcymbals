class BgJob
include Scraper	
 
def self.queue
    :scraperrr
  end	

  def self.perform shop
    Scraper.scrape shop
  end
end