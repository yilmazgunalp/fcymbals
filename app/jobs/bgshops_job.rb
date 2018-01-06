class BgshopsJob
include Scraper	
 
def self.queue
    :scrapeshops
  end	

  def self.perform shop
    Retailer.csv_import(Scraper.scrape(shop))
    Resque.enqueue(MaillogJob,"#{Rails.root}/log/Retailer_Update_log.txt",shop,:updated)
    Resque.enqueue_in(1.hour,DeactJob,shop)
    Resque.enqueue_in(2.hours,AllocateJob,shop)
end
end