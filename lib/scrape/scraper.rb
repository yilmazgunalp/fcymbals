module Scraper 
require 'csv'


AGENT = Mechanize.new
AGENT.user_agent_alias = 'Mac Safari'
LOG_FILE = File.open("#{Rails.root}/log/Retailer_Scrape_log.txt","a+")
TAGS = YAML.load_file("#{Rails.root}/lib/scrape/css_tags.yml")
MERCHANTS = YAML.load_file("#{Rails.root}/lib/scrape/merchants.yml")


def self.scrape klass
puts "inside Scraper scrape"	
b = Time.now
LOG_FILE << "\n===>\tSCRAPING [#{klass.upcase}] on #{b}...\n\n"	
result = Object.const_get(self.to_s + "::" + klass.capitalize).scrape
LOG_FILE << "Scraping completed in  #{Time.now - b}...\n"
LOG_FILE.flush
Resque.enqueue(MaillogJob,File.path(LOG_FILE),klass.to_s,:scraped)
result 
end

DEFAULT_OPTIONS = {
title: -> (item,selector) {item.at_css(selector).text.strip.downcase!},
picture_url: ->(pic_url,base_url) {pic_url.match(/^http/) ? pic_url : URI.parse(base_url) + pic_url},
pic_url: -> (item,selector) {item.at_css(selector)['src']},
link_url: -> (item,selector) {item.at_css(selector)['href']},
price: -> (item,selector) {item.at_css(selector).text.gsub(/,/,"").match(/\d+/)[0].to_i},
effective_price: ->(price,s_price) { [price,s_price].compact.min }  
}


private
def self.csv_import page,merchant,shop,file, opts = nil
	options = DEFAULT_OPTIONS.merge(opts)
	page_address = defined?(page.uri) ? page.uri.to_s : page.url
	LOG_FILE << "On Page #{page_address}...\n ..Found #{page.css(TAGS[merchant]['product']).length} products..\n"
		page.css(TAGS.dig(merchant,"product")).each do |item|
		
		title =  options[:title].call(item,TAGS.dig(merchant,'title'))

		begin # begin rescue block for price	
		price = options[:price].call(item,TAGS.dig(merchant,'price')) unless item.at_css(TAGS.dig(merchant,'price')).nil?
		s_price = options[:price].call(item,TAGS.dig(merchant,'s_price')) unless item.at_css(TAGS.dig(merchant,'s_price')).nil?
		price = options[:effective_price].call(price,s_price)
	    rescue StandardError => e
	 	log_error(binding,"price")
	 	end # end rescue block for price	
	 
		pic_url =  options[:pic_url].call(item,TAGS.dig(merchant,'picture'))
		picture_url = options[:picture_url].call(pic_url,shop['url'])
	
		#product page link and description on that page 
		link_url = options[:link_url].call(item,TAGS.dig(merchant,'link'))
	
		#error handling for invalid links
		begin # begin rescue block for link_url
		link_url.match(/^http/)? link = link_url : link = URI.parse(shop['url'])+link_url
		rescue StandardError => e
	 	log_error(binding,"link")
		link = "Link Not Found"		
		end # end rescue block for link_url
	
	# description = Mechanize::Page::Link.new(item.at_css(TAGS[merchant]['link']),
    # AGENT,page).click.css(TAGS[merchant]['desc']).text

    	if options[:code]
    		code = options[:code].call(AGENT.get(link), TAGS.dig(merchant,"code"))
    	end #if options[:code]	
	
	file << [title,price,s_price,picture_url,merchant,link,code].inject([]) {|row,col| row << col.to_s}
	
	end	# page.css each
GC.start
	sleep(1)	
LOG_FILE << "Page completed....\n\n"
LOG_FILE.flush
#sleep(1)
end # csv_import()



def self.log_error(binding,error_type)
		LOG_FILE << "[#{binding.eval("merchant").upcase}]: [SCRAPE::#{error_type.upcase}]: ITEM IN ERROR =>\n"	
		LOG_FILE <<  binding.eval("title") 
		LOG_FILE << "\n[ERROR MESSAGE]: #{binding.eval("e").message}\n"
		LOG_FILE << "[STACK TRACE]:\n" 
		binding.eval("e").backtrace.select {|e| e.match(/^#{Rails.root}/)}.each {|e| LOG_FILE << e +"\n"}
		LOG_FILE << "\n"
		LOG_FILE.flush
end #log_error()


end #Module Scraper

