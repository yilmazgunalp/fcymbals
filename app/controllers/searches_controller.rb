class SearchesController < ApplicationController

	def home
		render 'search'
	end	

	def search
		@makers,@facets = Solr.search(params[:q])[0], Solr.search(params[:q])[1]
		@retailers = []
		@makers.each() {|m| Maker.find(m).retailers.each() {|r| @retailers << r}}
		render 'results'
	end

	def getfacets()
		results = []
		params[:makers].split("-").each do |m|
			 results +=  Maker.find(m).retailers.pluck(:merchant,:title,:price)
		end	
		render json: results
	end	

end
