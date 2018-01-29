class AllocateJob
 
def self.queue
    :allocateretailers
  end	

  def self.perform merchant
    Retailer.where(merchant: merchant, maker_id: 3604).map(&:allocate)
    # log_file = File.open("#{Rails.root}/log/Retailer_Allocate_log.txt")
    Resque.enqueue(MaillogJob,File.path(Productmatch::LOG_FILE),merchant,:allocated)
  end
end