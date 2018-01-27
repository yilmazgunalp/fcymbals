require 'textobj.rb'
require 'strobj.rb'
module Productmatch

	BRANDS = ["istanbul mehmet","zildjian","sabian","meinl","paiste","ufip","istanbul", "bosphorus"]
	TYPES = Maker.select(:kind).distinct.map(&:kind).sort{|a,b| b.split(" ").length <=> a.split(" ").length }.map {|e| Strobj.new(e)} 
	SERIES = YAML.load_file("#{Rails.root}/lib/allocate/series.yml")
	MODELS = YAML.load_file("#{Rails.root}/lib/allocate/models.yml")
	LOG_FILE = File.new("#{Rails.root}/log/Retailer_Allocate_log.txt","w")
	SETMODELS = YAML.load_file("#{Rails.root}/lib/allocate/setmodels.yml")

	class << self 
	def match_maker(product_title)
		result = {}
		result[:brand] = match_brand(product_title)
		result[:kind] = match_kind(product_title) 
		result[:size] = match_size(product_title) unless result[:kind] == "set"
		series_and_model = match_series_and_model(product_title,result[:brand],result[:kind]) 
		result[:series],result[:model] = series_and_model[0],series_and_model[1]
		result
		rescue NoBrandError,NoKindError => e
		raise Retailer::NoMatchError.new(result)
	end #match_maker   
	private
	def match_brand(product_title)
		BRANDS.each do |b|
			return b if product_title.downcase.match(b)
		end #brands.each
		raise NoBrandError
	end #match_brand  
	def match_kind(product_title)
		puts "inside match_kind"
		product_title.downcase!	
		TYPES.each do |t|
			return t.match(product_title) if t.match(product_title)
		end #types.each
		raise NoKindError
	end #match_kind  
	def match_size(product_title)
		puts "inside match_size"
		product_title.match(/(\d+)"/) {|m| m[1] } 
	end #match_size 
	def match_series_and_model(product_title,brand,kind)
		puts "inside match_series_and_model"
		# brand = match_brand(product_title)
		if series = match_series(product_title,brand)
			if model = match_model_by_series(product_title,brand,kind,series)
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
	def match_series(product_title,brand)
		puts "inside match_series"
		product_title.downcase!	
		SERIES[brand].keys.each do |s| 
		return s if product_title.match(s)
		return s if Textobj.new(s,vars: true).match(product_title,multi: true)
		end #each 
		nil
	end #match_series	
	def match_model_by_series(product_title,brand,kind,serie)
		puts "inside match_model_by_series"
		if kind == "set" && SETMODELS.dig(brand,serie)
			SETMODELS.dig(brand,serie).each do |sm|
				return sm if Textobj.new(sm,vars: true).match(product_title,multi: true)
			end #each setmodel	
		else
			SERIES.dig(brand,serie).each do |m|
				return m if product_title.match(m)
				return m if Textobj.new(m,vars: true).match(product_title,multi: true)
			end #each
		end #if  
		nil
	end #match_model_by_series
	def match_model_by_brand(product_title,brand)
		MODELS[brand].each do |m|
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
