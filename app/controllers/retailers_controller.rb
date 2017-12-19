class RetailersController < ApplicationController
	include RetailersHelper
	include Scraper
	

def test
# Resque.enqueue(BgshopsJob,params["shop"])
# render inline: "Done!!!"
LogsMailer.log_email
render inline: "mail sent"
end	

def scrape  
	Retailer.csv_import(File.open(Scraper.scrape(params["shop"])))
	render inline: "Done!!!"
end

def index
	@retailers = Retailer.where("title LIKE ?", '%Sabian%')
	puts @retailers.count
	@retailers.each do |r|

	find_maker r 
	end


end	

private

def find_maker r
	
	begin
	brand = get_match $brands,r.title
	type = get_match $types,r.title,:type
	
	size =  if r.title.match(/(\d+)"/)
	r.title.match(/(\d+)"/)[1]
	else
	'null'	
	end
	
	series = get_match $models[brand].keys.sort_by { |word| word.length*-1},r.title,:series,brand
	
	
	model = get_match $models.dig(brand,series).sort_by { |word| word.length*-1},r.title,:mis,brand
	
	model_by_size = get_match $sizes.dig(brand,series,type,size),r.title, :mis,brand
	
	
	return if  find_by_code Maker.where(brand: brand),r 
	return if find_by_series brand,type,size,series,model,r
	return if find_by_size brand,type,size,series,model_by_size,r
	
	rescue => e
	puts r.title
	puts e
	puts  e.backtrace
	end
		
	@@logs.write "NO MATCH FOUND =>\t" + "Retailer: " + r.id.to_s + r.title + "\n"
	
end	


def find_by_code makers,retailer
	makers.each do  |m|
	if m.code && retailer.title.downcase.match("#{m.code}\s") 
	update_maker retailer,m,@@logs
	return	m
	end	
	end
	nil
end	

def find_by_series brand,type,size,series,model,retailer
	makers = Maker.where(brand: brand, kind: type,size: size,series: series,model: model)
	if !makers.empty?
		if makers.length == 1 
		update_maker retailer,makers.first,@@logs
		return makers.first
		else
		@@logs.write("Retailer: " + retailer.id.to_s + ": has multiple match with id's: #{makers.map {|m| m.id}}\n")
		return nil		
		end
	else	
	nil
	end
end	

def find_by_size brand,type,size,series,model,retailer
	makers = Maker.where(brand: brand, kind: type,size: size,series: series,model: model)
	if !makers.empty?
		if makers.length == 1 
		update_maker retailer,makers.first,@@logs
		return makers.first
		else
		@@logs.write("Retailer: " + retailer.id.to_s + ": has multiple match with id's: #{makers.map {|m| m.id}}\n")	
		return nil		
		end
	else	
	nil
	end
end	


end






