class RetailersController < ApplicationController
include Solr	

def allocate 
	@rsp = Solr.connect(Retailer.where(merchant: params[:merchant], maker_id: 3604))
	@rsp.each do |k,v|
	if v.length == 1 || (!v.empty? && v[0]['score'] - v[1]['score'] > 1)
	Maker.find(v[0]["id"]).retailers << k
	@rsp.delete(k) unless params["res"] == "all"
	end#if 		
	end	#rsp.each
end #allocate

end #class RetailersController


