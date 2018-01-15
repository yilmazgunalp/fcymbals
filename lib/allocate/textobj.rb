class Textobj
	@@variants = YAML.load_file("#{Rails.root}/lib/allocate/vars.yml")
	attr_reader :text,:tokens,:alternatives

	def initialize(text, vars = false)
		@text = text	
		if vars 
			@tokens = tokenize_with_alternative_spellings(text)
			@alternatives = 
		else
			@tokens = text.split(" ").map {|t| Strobj.new(t)}	
		end #if vars	
	end	

	def match(string)

	end #match	

	private 

	def tokenize_with_alternative_spellings(text)
		strobjs = []
		i = 0
		variants.keys.each do |varskey|
			if text.match(varskey)
				strobjs << Strobj.new(varskey)
				amend_text(text,varskey,i)
			end #if text.match
		end #each variants.keys	

		variants.values.each do |varsvalue|
			varsvalue.each do |v|
				if text.match(v)
				strobjs << Strobj.new(variants.key(varsvalue))
				amend_text(text,v,i)
				end #if text.match

			end # each varsvalue	

		end #each variants.values	

		result = []
		text.split(" ").each do |t|
			if j = t.match(/token_(\d+)/){|m| m[1]}
			result << strobjs[j]
			else
			result << Strobj.new(t)	
			end #if t.match	
		end #text.split.each	
		result	
	end	 #tokenize_with...

	def make_alternative_spellings 
		

	end #make_alternative_spellings	

	def amend_text(text,mtch,suffix)
		text.sub!(mtch,"token_#{suffix}")
		suffix += 1 
	end #amend_text 

end #class Textobj