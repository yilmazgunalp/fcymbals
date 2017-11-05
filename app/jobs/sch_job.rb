class SchJob

def self.queue
    :sch
  end	

  def self.perform
    puts 'I am scheduled to run every 30 seconds'
    end
end