class TestJob

def self.queue
    :test
  end	

  def self.perform x
	puts "...TEST...THIS JOB IS SCHEDULED TO RUN  EVERY #{x} MINUTE.."        
  end
end