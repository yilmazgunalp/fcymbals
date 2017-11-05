class CleanupJob 
	@queue = :myq 

    
  def self.perform(m)
   puts "<-------START JOB---------->"
   puts "<----I AM A JOB------------------>"
   puts "<-------------------------------->"
  
   p Maker.find(m).dup
   puts "<--------END JOB------------->"
  end
end
