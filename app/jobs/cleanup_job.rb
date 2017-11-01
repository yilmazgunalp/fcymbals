class CleanupJob 
	@queue = :myq 

    @@file = File.new("#{Rails.root}/log/deneme.txt")
  def self.perform(m)
   puts "<-------START JOB---------->"
   puts "<----I AM A JOB------------------>"
   puts "<-------------------------------->"
   File.open(@@file, 'a+') {|f| f.write m }
   p Maker.find(m).dup
   puts "<--------END JOB------------->"
  end
end
