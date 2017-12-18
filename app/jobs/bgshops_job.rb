class BgshopsJob
include Scraper	
 
def self.queue
    :scrapeshops
  end	

  def self.perform shop
    Retailer.csv_import(Scraper.scrape(shop))
    Resque.enqueue_in(1.hour,DeactJob,shop)
end
end