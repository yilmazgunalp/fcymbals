class DeactJob
 
def self.queue
    :scrapeshops
  end	

  def self.perform merchant
    Retailer.deactivate_records(merchant,Time.now+5.minutes)
  end
end