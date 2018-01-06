class RetailersController < ApplicationController
	include RetailersHelper
	include Scraper
	
	

def test
# Resque.enqueue(BgshopsJob,params["shop"])
# render inline: "Done!!!"
LogsMailer.log_email("#{Rails.root}/log/Retailer_Scrape_log.txt","mymerchant6000","action63333").deliver
render inline: "mail sent"
end	#test


def allocate
# Resque.enqueue(YamlseriesJob)
# Resque.enqueue(YamlmodelsJob)
@retailers = Retailer.where(merchant: 'abh')
	@retailers.each do |r|
	puts r.title
	puts r.allocate
	puts "----------------------------------"
	end
render inline: "allocated"
end #allocate

def index
	
end	#index

private 

end #class RetailersController






