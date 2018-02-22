class RetailersController < ApplicationController
include Solr	

def allocate 
	@rsp = Solr.connect(Retailer.where(merchant: params[:merchant], maker_id: 3604))
end #allocate

end #class RetailersController

