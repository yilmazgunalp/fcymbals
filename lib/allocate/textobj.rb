class Textobj
	@@variants = YAML.load_file("#{Rails.root}/lib/allocate/vars.yml")
	attr_reader :text,:tokens,:alternatives
	include Allocatehelper

	def initialize(text, vars = false)
		@text = text
		if vars 
			@tokens = tokenize(text.dup)
			@alternatives = make_alternative_spellings
		else
			@tokens = text.split(" ").map {|t| Strobj.new(t)}	
		end #if vars	
	end	#initialize

	def match(string,multi = false)
	  if multi
	   	return text if tokens&(Textobj.new(string,vars: true).tokens) == tokens 
	  else   
	    alternatives.each {|a| return text if string.match(a)}
	  end #if multi
		nil  
  	end #match
  
  def inspect
  tokens.inject([]) {|m,t| m << t.string}
  end  

	private 
	def tokenize(text)
	 strobjs = []
		i = 0
		@@variants.keys.each do |varskey|
		  if text.match(varskey)
				strobjs << Strobj.new(varskey)
				amend_text(text,varskey,i)
				i += 1 
			end #if text.match
		end #each variants.keys	

		@@variants.values.each do |varsvalue|
			varsvalue.each do |v|
				if text.match(v)
				strobjs << Strobj.new(@@variants.key(varsvalue))
				amend_text(text,v,i)
				i += 1 
				end #if text.match
			end # each varsvalue	
		end #each variants.values	

		result = []
		text.split(" ").each do |t|
			if j = t.match(/token_(\d+)/){|m| m[1]}
			result << strobjs[j.to_i]
			else
			result << Strobj.new(t)	
			end #if t.match	
		end #text.split.each	
		result	
	end	 #tokenize
	
	def make_alternative_spellings
	  result = []
	  tokens.each do |strobj|
	    if strobj.alternatives 
	    	result << (strobj.alternatives << strobj.string)
	    else
	    	result << [strobj.string]   
	    end #if strobj.alternatives
    	end
  		explode(result)  
	end #make_alternative_spellings	
end #class Textobj