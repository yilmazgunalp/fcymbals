module Scraper 
require 'csv'

class << self 
attr_accessor :agent,:tags,:merchants,:log_file
end	

@agent = Mechanize.new
@agent.user_agent_alias = 'Mac Safari'

@log_file = File.open("#{Rails.root}/log/Retailer_Scrape_log.txt","a+")
@tags = YAML.load_file("#{Rails.root}/lib/scrape/css_tags.yml")
@merchants = YAML.load_file("#{Rails.root}/lib/scrape/merchants.yml")


def self.scrape klass
b = Time.now
log_file << "\n===>\tSCRAPING [#{klass.upcase}] on #{b}...\n\n"	
result = Object.const_get(self.to_s + "::" + klass.capitalize).scrape
log_file << "Scraping completed in  #{Time.now - b}...\n"
log_file.flush
Resque.enqueue(MaillogJob,File.path(log_file),klass.to_s,:scraped)
result
end

DEFAULT_OPTIONS = {
title: -> (item,selector) {item.at_css(selector).text.strip!.downcase!},
picture_url: ->(pic_url,base_url) {pic_url.match(/^http/) ? pic_url : URI.parse(base_url) + pic_url},
pic_url: -> (item,selector) {item.at_css(selector)['src']},
link_url: -> (item,selector) {item.at_css(selector)['href']},
price: -> (item,selector) {item.at_css(selector).text.gsub!(/,/,"").match(/\d+/)[0].to_i},
effective_price: ->(price,s_price) { [price,s_price].compact!.min }  
}


private
def self.csv_import page,merchant,shop,file, opts = nil
	options = DEFAULT_OPTIONS.merge(opts)
	page_address = defined?(page.uri) ? page.uri.to_s : page.url
	log_file << "On Page #{page_address}...\n ..Found #{page.css(@tags[merchant]['product']).length} products..\n"
		page.css(tags.dig(merchant,"product")).each do |item|
	
		title =  options[:title].call(item,tags.dig(merchant,'title'))
			
		begin # begin rescue block for price	
		price = options[:price].call(item,tags.dig(merchant,'price')) unless item.at_css(tags.dig(merchant,'price')).nil?
		s_price = options[:price].call(item,tags.dig(merchant,'s_price')) unless item.at_css(tags.dig(merchant,'s_price')).nil?
		price = options[:effective_price].call(price,s_price)
	    rescue StandardError => e
	 	log_error(binding,"price")
	 	end # end rescue block for price	
	 
		pic_url =  options[:pic_url].call(item,tags.dig(merchant,'picture'))
		picture_url = options[:picture_url].call(pic_url,shop['url'])
	
		#product page link and description on that page 
		link_url = options[:link_url].call(item,tags.dig(merchant,'link'))
	
		#error handling for invalid links
		begin # begin rescue block for link_url
		link_url.match(/^http/)? link = link_url : link = URI.parse(shop['url'])+link_url
		rescue StandardError => e
	 	log_error(binding,"link")
		link = "Link Not Found"		
		end # end rescue block for link_url
	
	# description = Mechanize::Page::Link.new(item.at_css(@tags[merchant]['link']),
    # @agent,page).click.css(@tags[merchant]['desc']).text

    	if options[:code]
    		code = options[:code].call(@agent.get(link), tags.dig(merchant,"code"))
    	end #if options[:code]	
	
	file << [title,price,s_price,picture_url,merchant,link,code].inject([]) {|row,col| row << col.to_s}
	GC.start
	sleep(1)
	end	# page.css each
	
log_file << "Page completed....\n\n"
log_file.flush
#sleep(1)
end # csv_import()



def self.log_error(binding,error_type)
		log_file << "[#{binding.eval("merchant").upcase}]: [SCRAPE::#{error_type.upcase}]: ITEM IN ERROR =>\n"	
		log_file <<  binding.eval("title") 
		log_file << "\n[ERROR MESSAGE]: #{binding.eval("e").message}\n"
		log_file << "[STACK TRACE]:\n" 
		binding.eval("e").backtrace.select {|e| e.match(/^#{Rails.root}/)}.each {|e| log_file << e +"\n"}
		log_file << "\n"
		log_file.flush
end #log_error()


end #Module Scraper

