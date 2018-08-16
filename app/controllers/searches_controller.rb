class SearchesController < ApplicationController

	def home
		render 'search'
	end	

	def search
		@makers = Solr.search(params[:q])[0]
		@retailers = []
		@makers.each() {|m| Maker.find(m).retailers.active.each() {|r| @retailers << r}}
    if @retailers.empty? 
    @no_result = true
    @retailers = Retailer.limit(100).order('RANDOM()').where.not(maker_id: 3604).where(active: true)
    end
		render 'results'
	end
end
