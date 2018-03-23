class AllocateJob
 
def self.queue
    :allocateretailers
  end	

  def self.perform merchant
  	count = Retailer.where(merchant: merchant).count/100
  	workerpool = WorkerPool.new(3)
  	count.times do |i| 
  		workerpool << "Retailer.alloc(\"#{merchant}\",'all',nil,100,#{(i)*100})"
  	 	puts "putting jobs in the pool#{i}\n"
  	end
  	workerpool << :done
  	workerpool.wait
    Resque.enqueue(MaillogJob,File.path(Solr::MATCH_LOG_FILE),merchant,:allocated)
  end
end


