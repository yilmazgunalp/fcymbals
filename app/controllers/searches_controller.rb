class SearchesController < ApplicationController

	def home
		render 'search'
	end	

	def search
		@makers = Solr.search(params[:q])
		@retailers = []
		@makers.each() {|m| Maker.find(m).retailers.each() {|r| @retailers << r}} 
		render 'results'	
	end

end
