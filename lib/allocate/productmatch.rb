module Productmatch
  
class << self 
attr_accessor :brands,:types  

def match_brand(product_title)
  brands.each do |b|
  return b if product_title.downcase.match(b)
  end #brands.each
  raise NoBrandError, "FATAL: No matching brand"
end #match_brand  
  
def match_kind(product_title)
  product_title.downcase!	
  types.each do |t|
  return t.match(product_title) if t.match(product_title)
  end #types.each
  raise NoKindError, "FATAL: No matching cymbal type"
	rescue NoKindError
	puts "!!!..NO CYMBAL TYPE FOUND...!!"	
end #match_kind  


def match_size(product_title)
  product_title.match(/(\d+)"/) {|m| m[1] } 
end #match_size 

def match_series(product_title)
product_title.downcase!	
YAML.load_file("#{Rails.root}/lib/allocate/series.yml")[match_brand(product_title)].keys.each do |s| 
return s if product_title.match(s)
end #each 
"NO SERIES"
end #match_series	

end # class << self

class NoBrandError < StandardError
end    
class NoKindError < StandardError
end 
class NoSeriesError < StandardError
end 

end #module ProductMatch


Productmatch.brands = ["istanbul mehmet","zildjian","sabian","meinl","paiste","ufip","istanbul", "bosphorus"]
Productmatch.types = [Strobj.new("ride"),Strobj.new("crash"),Strobj.new("hi hat"),Strobj.new("splash"),Strobj.new("bell"),
	Strobj.new("flat ride"),Strobj.new("crash ride"),Strobj.new("china")]

