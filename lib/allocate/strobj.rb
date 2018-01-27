class Strobj
	VARS = YAML.load_file("#{Rails.root}/lib/allocate/vars.yml")
	attr_reader :string,:alternatives

	def initialize(string)
		@string = string
		@alternatives = VARS[string] 	
	end #initialize()

	def match(text)
		text.downcase!
		return string if text.match(string)
		if alternatives
		alternatives.each do |a|
		return string  if text.match(a)
		end #each
		end #if alternatives
		#if no match return nil
		nil  
	end #match()  

	def hash 
    	string.hash
  	end
  
  	def eql?(other)
    	hash == other.hash
  	end  

end #class Strobj  
