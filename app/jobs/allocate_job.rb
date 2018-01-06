class AllocateJob
 
def self.queue
    :allocateretailers
  end	

  def self.perform merchant
    Retailer.where(merchant: merchant, maker_id: 3604).each {|r| r.allocate }
    log_file = File.open("#{Rails.root}/log/Retailer_Allocate_log.txt")
    Resque.enqueue(MaillogJob,File.path(log_file),merchant,:allocated)
  end
end