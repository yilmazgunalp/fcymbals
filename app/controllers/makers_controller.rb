class MakersController < ApplicationController
  def index
  	@cymbals = Maker.all
  	@r = Retailer.new

  end
end
