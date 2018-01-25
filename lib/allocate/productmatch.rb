module Productmatch
	class << self 
	attr_accessor :brands,:types,:series,:models,:setmodels,:log_file
	def match_maker(product_title)
		result = {}
		result[:brand] = match_brand(product_title)
		result[:kind] = match_kind(product_title) 
		result[:size] = match_size(product_title) unless result[:kind] == "set"
		result[:series] = match_series_and_model(product_title)[0]
		result[:model] = match_series_and_model(product_title)[1]
		result
		rescue NoBrandError,NoKindError => e
		raise Retailer::NoMatchError.new(result)
	end #match_maker   
	private
	def match_brand(product_title)
		brands.each do |b|
			return b if product_title.downcase.match(b)
		end #brands.each
		raise NoBrandError
	end #match_brand  
	def match_kind(product_title)
		product_title.downcase!	
		types.each do |t|
			return t.match(product_title) if t.match(product_title)
		end #types.each
		raise NoKindError
	end #match_kind  
	def match_size(product_title)
		product_title.match(/(\d+)"/) {|m| m[1] } 
	end #match_size 
	def match_series_and_model(product_title)
		brand = match_brand(product_title)
		if series = match_series(product_title)
			if model = match_model_by_series(product_title,brand,series)
				return [series,model]
			else
				return [series,nil]	
			end #if model	
		elsif model = match_model_by_brand(product_title,brand)
			return [nil,model]	
		else
			return [nil,nil]	
		end #if series
	end #match_series_and_model 	
	def match_series(product_title)
		product_title.downcase!	
		series[match_brand(product_title)].keys.each do |s| 
		return s if product_title.match(s)
		return s if Textobj.new(s,vars: true).match(product_title,multi: true)
		end #each 
		nil
	end #match_series	
	def match_model_by_series(product_title,brand,serie)
		if match_kind(product_title) == "set" && setmodels.dig(brand,serie)
			setmodels.dig(brand,serie).each do |sm|
				return sm if Textobj.new(sm,vars: true).match(product_title,multi: true)
			end #each setmodel	
		else
			series.dig(brand,serie).each do |m|
				return m if product_title.match(m)
				return m if Textobj.new(m,vars: true).match(product_title,multi: true)
			end #each
		end #if  
		nil
	end #match_model_by_series
	def match_model_by_brand(product_title,brand)
		models[brand].each do |m|
		return m if product_title.match(m)
		end #each 
		nil
	end #match_model_by_brand
	end #class << self
	class NoBrandError < StandardError
	end    
	class NoKindError < StandardError
	end 
end #module ProductMatch
Productmatch.brands = ["istanbul mehmet","zildjian","sabian","meinl","paiste","ufip","istanbul", "bosphorus"]
Productmatch.types = 
Maker.select(:kind).distinct.map {|m| m.kind}.sort{|a,b| b.split(" ").length <=> a.split(" ").length }.map {|e| Strobj.new(e)}
Productmatch.series = YAML.load_file("#{Rails.root}/lib/allocate/series.yml")
Productmatch.models = YAML.load_file("#{Rails.root}/lib/allocate/models.yml")
Productmatch.log_file = File.new("#{Rails.root}/log/Retailer_Allocate_log.txt","w")
Productmatch.setmodels = YAML.load_file("#{Rails.root}/lib/allocate/setmodels.yml")
