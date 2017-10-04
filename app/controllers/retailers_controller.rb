class RetailersController < ApplicationController
	include RetailersHelper
	include Scraper

@@logs = File.open($log_file,'a+')

def scrape  
page = Scraper.get_data params['shop']
render inline: page.body
end

def index
@retailers = Retailer.first(10)
@retailers.each do |r|
find_maker r
end
end	



private

def find_maker r

	brand = get_match $brands,r.title
	type = get_match $types,r.title
	size = r.title.match(/(\d+)"/)[1]
	series = get_match $models[brand].keys,r.title
	model = get_match $models[brand][series],r.title

	maker = Maker.where(brand: brand, kind: type,size: size,series: series,model: model).first
		
	if maker.nil?
	 	@@logs.write ("Retailer: " + r.id.to_s + ": ")
	 	@@logs.write r.title+"\n"
	else
	r.maker = maker	
	# r.save!
	end


end	


end






