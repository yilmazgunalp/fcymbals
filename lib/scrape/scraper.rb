module Scraper 
require 'csv'

class << self 
attr_accessor :agent,:tags,:merchants,:log_file
end	

@agent = Mechanize.new
@agent.user_agent_alias = 'Mac Safari'

@log_file = Logger.new("#{Rails.root}/log/Retailer_Scrape_log.txt")
@tags = YAML.load_file("#{Rails.root}/lib/scrape/css_tags.yml")
@merchants = YAML.load_file("#{Rails.root}/lib/scrape/merchants.yml")


def self.scrape klass
b = Time.now
log_file << "Scraping #{klass} on #{b}...\n"	
Object.const_get(self.to_s + "::" + klass.capitalize).scrape
log_file << "Scraping completed in  #{Time.now - b}...\n"	
end

DEFAULT_OPTIONS = {
title: ->(text){text.strip},
picture_url: ->(pic_url,base_url) {pic_url.match(/^http/) ? pic_url : URI.parse(base_url) + pic_url}

}


private
def self.csv_import page,merchant,shop,file, opts = nil
options = DEFAULT_OPTIONS.merge(opts)

log_file << "On Page #{page.uri}...\n ..Found #{page.css(@tags[merchant]['product']).length} products..\n"
 page.css(@tags[merchant]['product']).each do |item|

	title = item.at_css(@tags[merchant]['title']).text
	title = options[:title].call(title) 

		begin
		price = ->() {item.at_css(@tags[merchant]['price']).text.match(/\d+/)[0].to_i}.call()
		s_price = item.at_css(@tags[merchant]['s_price']).text.match(/[\d,]+/)[0].to_f unless item.at_css(@tags[merchant]['s_price']).nil?
	 	rescue => e
	 	price = 0	
	 	end #begin	
	 
	pic_url = item.at_css(@tags[merchant]['picture'])['src']
	picture_url = options[:picture_url].call(pic_url,shop['url'])
	
	#product page link and description on that page 
	link_url = item.at_css(@tags[merchant]['link'])['href']
		begin
		link_url.match(/^http/)? link = link_url : link = URI.parse(shop['url'])+link_url
		rescue => e
		log_file <<  e.message 
		log_file << "\n"
		link = "Link Not Found"
		end # begin
	# description = Mechanize::Page::Link.new(item.at_css(@tags[merchant]['link']),
    # @agent,page).click.css(@tags[merchant]['desc']).text
	sleep(1)

	 row = []
	 [title,price,s_price,picture_url,merchant,link].each {|col| row << col.to_s}

	 file << row
# sleep(2) 
end	# page.css each
end # csv_import()
end #Module Scraper

