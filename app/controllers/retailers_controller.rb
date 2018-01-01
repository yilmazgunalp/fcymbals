class RetailersController < ApplicationController
	include RetailersHelper
	include Scraper
	include Productmatch
	

def test
# Resque.enqueue(BgshopsJob,params["shop"])
# render inline: "Done!!!"
LogsMailer.log_email("#{Rails.root}/log/Retailer_Scrape_log.txt","mymerchant6000","action63333").deliver
render inline: "mail sent"
end	#test


def allocate
# Resque.enqueue(YamlseriesJob)
# Resque.enqueue(YamlmodelsJob)
@retailers = Retailer.all
	@retailers.each do |r|
	puts r.title	
	puts Productmatch.match_brand(r.title)
	puts Productmatch.match_size(r.title)
	puts Productmatch.match_kind(r.title)
	puts Productmatch.match_series_and_model(r.title)
	puts "----------------------------------"
	end

render inline: "allocated"
end #allocate




def index
	
end	#index

end #class RetailersController






