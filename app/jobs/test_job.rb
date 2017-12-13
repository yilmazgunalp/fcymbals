class TestJob

def self.queue
    :test
  end	

  def self.perform x
	puts "this is job #{x}"        
  end
end