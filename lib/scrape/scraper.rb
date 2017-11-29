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
puts "inside Scraper:scrape now"	
b = Time.now
log_file << "Scraping #{klass} on #{b}...\n"	
Object.const_get(self.to_s + "::" + klass.capitalize).scrape
log_file << "Scraping completed in  #{Time.now - b}...\n"	
end

DEFAULT_OPTIONS = {
title: -> (item,selector) {item.at_css(selector).text.strip},
picture_url: ->(pic_url,base_url) {pic_url.match(/^http/) ? pic_url : URI.parse(base_url) + pic_url},
pic_url: -> (item,selector) {item.at_css(selector)['src']},
link_url: -> (item,selector) {item.at_css(selector)['href']},
price: -> (item,selector) {item.at_css(selector).text.match(/\d+/)[0].to_i}
}


private
def self.csv_import page,merchant,shop,file, opts = nil
	options = DEFAULT_OPTIONS.merge(opts)

	puts  "On Page #{}...\n ..Found #{page.css(@tags[merchant]['product']).length} products..\n"
	 page.css(tags.dig(merchant,"product")).each do |item|

	title =  options[:title].call(item,tags.dig(merchant,'title'))
	
		begin
		price = options[:price].call(item,tags.dig(merchant,'price'))
		s_price = options[:price].call(item,tags.dig(merchant,'s_price')) unless item.at_css(tags.dig(merchant,'s_price')).nil?
	 	rescue => e
	 	price = 0	
	 	end #begin	
	 
	pic_url =  options[:pic_url].call(item,tags.dig(merchant,'picture'))
	picture_url = options[:picture_url].call(pic_url,shop['url'])
	
	#product page link and description on that page 
	link_url = options[:link_url].call(item,tags.dig(merchant,'link'))
		begin
		link_url.match(/^http/)? link = link_url : link = URI.parse(shop['url'])+link_url
		rescue => e
		log_file <<  e.message 
		log_file << "\n"
		link = "Link Not Found"
		end # begin
	# description = Mechanize::Page::Link.new(item.at_css(@tags[merchant]['link']),
    # @agent,page).click.css(@tags[merchant]['desc']).text
		 row = []
	 [title,price,s_price,picture_url,merchant,link].each {|col| row << col.to_s}

	 file << row
	end	# page.css each
log_file << "Page completed....\n"
sleep(2)

end # csv_import()

end #Module Scraper

