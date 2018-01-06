class DeactJob
 
def self.queue
    :deactretailers
  end	

  def self.perform merchant
    Retailer.deactivate_records(merchant,Time.now+5.minutes)
    log_file = File.open("#{Rails.root}/tmp/Retailer_Deact_log.txt","a+")
    Retailer.where("merchant = ? AND updated_at > ? AND active = ? ",merchant,Time.now-15.minutes,false).each do |r|
     log_file << r.to_log + "\n" 
    end 
    Resque.enqueue(MaillogJob,File.path(log_file),merchant,:deactivated)
  end
end