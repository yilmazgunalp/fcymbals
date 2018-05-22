class RetailersController < ApplicationController

	def allocate
		@rsp = Retailer.alloc(params[:merchant],params[:res],params[:rec])
	end #allocate

        def update 
         retailer = Retailer.find(params[:id])
        if params[:active] == "deactivate"
            retailer.update(active: false)
        elsif params[:active] == "activate"
            retailer.update(active: true)
        end
        
  	respond_to do |format| 
  		format.js
  		format.json
  	end #respond_to	
        end #update

  private
  def retailers_params
  params.require(:retailers).permit(:id)	
  end# makers_params 	
end #class RetailersController


