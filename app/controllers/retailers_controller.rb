class RetailersController < ApplicationController

def allocate 
	File.new(Productmatch::LOG_FILE, "w")
	@retailers = Retailer.where(merchant: params[:merchant], maker_id: 3604)
	@retailers.map(&:allocate)
@retailers = Retailer.where(merchant: params[:merchant], maker_id: 3604)

end #allocate

end #class RetailersController

