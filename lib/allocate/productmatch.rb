module Productmatch
  
class << self 
attr_accessor :brands,:types,:series,:models  

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


def match_series_and_model(product_title)
brand = match_brand(product_title)
if series = match_series(product_title)
	if model = match_model_by_series(product_title,brand,series)
	return "#{series}\n#{model}"	
	else
	# raise NoModelError
	# rescue NoModelError
	puts "#{series}\nNo Model Found"	
	end #if model	
elsif model = match_model_by_brand(product_title,brand)
	if series = match_series_by_model(brand,model)
	return "#{series}\n#{model}"		
	else
	# raise NoSeriesError
	# rescue NoSeriesError
	puts "No Series Found\n#{model}"	
	end #if series	
else
# raise NoSeriesorModelError
# rescue NoSeriesorModelError
puts "No Series or Model Found"	
end #if series


end #match_series_and_model 	


def match_series(product_title)
product_title.downcase!	
series[match_brand(product_title)].keys.each do |s| 
return s if product_title.match(s)
end #each 
nil
end #match_series	

def match_model_by_series(product_title,brand,serie)
series.dig(brand,serie).each do |m|
return m if product_title.match(m)
end #each 
nil
end #match_model_by_series

def match_model_by_brand(product_title,brand)
models[brand].each do |m|
return m if product_title.match(m)
end #each 
nil
end #match_model_by_brand


def match_series_by_model(brand,model)
result = Maker.where(brand: brand, model: model)	
if result.length == 1 
return result.first.series
else
return nil
end #if 	
end #match_series_by_model 


end # class << self

class NoBrandError < StandardError
end    
class NoKindError < StandardError
end 
class NoSeriesError < StandardError
end 
class NoModelError < StandardError
end 
class NoSeriesorModelError < StandardError
end 

end #module ProductMatch


Productmatch.brands = ["istanbul mehmet","zildjian","sabian","meinl","paiste","ufip","istanbul", "bosphorus"]
Productmatch.types = [Strobj.new("ride"),Strobj.new("crash"),Strobj.new("hi hat"),Strobj.new("splash"),Strobj.new("bell"),
	Strobj.new("flat ride"),Strobj.new("crash ride"),Strobj.new("china")]
Productmatch.series = YAML.load_file("#{Rails.root}/lib/allocate/series.yml")
Productmatch.models = YAML.load_file("#{Rails.root}/lib/allocate/models.yml")
