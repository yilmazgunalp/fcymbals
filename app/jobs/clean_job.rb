class CleanJob
 
def self.queue
    :cleanretailers
  end	

  def self.perform 
    #Delete records not updated in the last 15 days
    Retailer.clean_old_records(Time.now-15.days)
  end
end
