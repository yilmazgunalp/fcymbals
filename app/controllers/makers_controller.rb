class MakersController < ApplicationController
	
  def index
  	@cymbals = Maker.all
  end

  def edit 



  end	

  def update
  	maker = Maker.find(params[:id])
  	maker.retailers << Retailer.find(params[:r].to_i)
  	respond_to do |format| 
  		format.js
  		format.json
  	end #respond_to	
  	
  end #update

  def show
  @maker = Maker.find(params[:id])	
  end #show()	

  private 

  def makers_params
  params.require(:makers).permit(:id,:retailers)	
  end# makers_params 	
end
