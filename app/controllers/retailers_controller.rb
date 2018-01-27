class RetailersController < ApplicationController

def allocate 

@retailers = Retailer.where(merchant: params[:merchant], maker_id: 3604)
	@retailers.map(&:allocate)
@retailers = Retailer.where(merchant: params[:merchant], maker_id: 3604)
end #allocate

end #class RetailersController

