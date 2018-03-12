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

end
