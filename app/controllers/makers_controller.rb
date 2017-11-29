class MakersController < ApplicationController
  def index
  	@cymbals = Maker.all
  end
end
