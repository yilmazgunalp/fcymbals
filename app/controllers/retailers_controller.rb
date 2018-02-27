class RetailersController < ApplicationController

	def allocate
		@rsp = Retailer.alloc(params[:merchant],params[:res],params[:rec])
	end #allocate

end #class RetailersController


