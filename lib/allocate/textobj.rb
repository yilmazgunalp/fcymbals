class Textobj
	VARIANTS = YAML.load_file("#{Rails.root}/lib/allocate/vars.yml")
	attr_reader :text,:tokens,:alternatives
	include Allocatehelper

	def initialize(text, vars = false)
		# puts "inside Textobj init"
		
		@text = text
		if vars 
		# puts "inside vars"
			@tokens = tokenize(text.dup)	
			@alternatives = make_alternative_spellings
		else
			@tokens = text.split(" ").map {|t| Strobj.new(t)}	
		end #if vars
		
	end	#initialize

	def match(string,multi = false)
	  if multi
	  	if string.instance_of?(Textobj)
	  	return text if tokens&(string.tokens) == tokens 	
	  	else	
	   	return text if tokens&(Textobj.new(string,vars: true).tokens) == tokens 
	   	end #if string
	  else   
	    alternatives.each {|a| return text if string.match(a)}
	  end #if multi
		nil  
  	end #match
  
  def inspect
  tokens.inject([]) {|m,t| m << t.string}
  end  

	

	def add_token(word)
		if VARIANTS.keys.include?(word)
		  	# puts "inside varskey if"
			tokens << Strobj.new(word)
			return
		end #if VARIANTS

		VARIANTS.values.each do |varsvalue|
			# puts "inside varsvalue if"	
			if varsvalue.include?(word)
				tokens << Strobj.new(VARIANTS.key(varsvalue))
				return
			end #if varsvalue
		end #each variants.values	

		tokens << Strobj.new(word)
	end #add_token 


	def tokenize(text)

	# puts "inside tokenize"

	 strobjs = []
		i = 0
		VARIANTS.keys.each do |varskey|
		  if text.match(varskey)
		  		# puts "inside varskey if"
				strobjs << Strobj.new(varskey)
				amend_text(text,varskey,i)
				i += 1 
			end #if text.match
		end #each variants.keys	

		VARIANTS.values.each do |varsvalue|
			varsvalue.each do |v|
				if text.match(v)
				# puts "inside varsvalue if"	
				strobjs << Strobj.new(VARIANTS.key(varsvalue))
				amend_text(text,v,i)
				i += 1 
				end #if text.match
			end # each varsvalue	
		end #each variants.values	
		# p strobjs
		# p strobjs.length
		result = []
		
		text.split(" ").each do |t|
			# puts "inside text split"
			if j = t.match(/token_(\d+)/){|m| m[1]}
			result << strobjs[j.to_i]
			else
			result << Strobj.new(t)	
			end #if t.match	
		end #text.split.each
		result	

	end	 #tokenize
	
	def make_alternative_spellings
		# puts "inside alternative spelling"
	  result = []
	  tokens.each do |strobj|
	  	
	    if strobj.alternatives
	       	result << (strobj.alternatives.dup << strobj.string)
	    else
	    	result << [strobj.string]   
	    end #if strobj.alternatives
    	end
    	
  	  	explode(result)
  	end #make_alternative_spellings	
	

end #class Textobj