class AllocateJob
 
def self.queue
    :allocateretailers
  end	

  def self.perform merchant
    Retailer.alloc(merchant,'all',nil,true)
    Resque.enqueue(MaillogJob,File.path(Solr::MATCH_LOG_FILE),merchant,:allocated)
  end
end