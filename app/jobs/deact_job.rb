class DeactJob
 
def self.queue
    :deactretailers
  end	

  def self.perform merchant
    #This job was queued 1 hour ago so give another hour as buffer and deactivae records if they
    #have not been updated in the last two hours
    Retailer.deactivate_records(merchant,Time.now-2.hours)
    log_file = File.open("#{Rails.root}/tmp/Retailer_Deact_log.txt","a+")
    #Get all the records that has been updated in the last 15 minutes and inactive and write them  to log
    #  15 minute mark is to catch only the records made inactive  in the last scraping job
    Retailer.where("merchant = ? AND updated_at > ? AND active = ? ",merchant,Time.now-15.minutes,false).each do |r|
        log_file << "#{r.to_log}\n" 
    end 
    log_file.flush.close
    Resque.enqueue(MaillogJob,File.path(log_file),merchant,:deactivated)
  end
end