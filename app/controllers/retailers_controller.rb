class RetailersController < ApplicationController
	include RetailersHelper

def scrape_gh

agent = Mechanize.new
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

page = agent.get "https://www.ghmusic.com.au/drums/cymbals/?limit=10"

default_maker = Maker.find(20357)

logs = File.open(RetailersHelper::log_file,'a+')

page.css('.item-content').each do |item|
 r = Retailer.new
 r.price = item.css('.price'&& '.redprice').text.match(/\d+/)[0].to_f
 r.s_price = item.css('.specialPrice').text.match(/\d+/)[0].to_f
 r.title = item.css('.pro_title').text
 title = item.css('.pro_title').text

 
 r.merchant = "gh music"
 brand = get_match $brands,title
 type = get_match $types,title
 size = title.match(/(\d+)"/)[1]
 series = get_match $models[brand.to_s].keys,title
 model = get_match $models[brand.to_s][series.to_s],title
 puts series
 puts model
 maker = Maker.where(brand: brand, kind: type,size: size,series: series,model: model).first
 r.maker = maker || default_maker
 r.save
 if maker.nil?
 	logs.write ("Retailer: " + r.id.to_s + ": ")
 	logs.write title+"\n"

end

end	

render inline: page.body


	
end



def index

@retailers = Retailer.all


end	


end






