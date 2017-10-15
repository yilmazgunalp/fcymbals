module Scraper 
@agent = Mechanize.new
@agent.user_agent_alias = 'Mac Safari'	
@agent.log = Logger.new "mech.log"
@tags = YAML.load_file("#{Rails.root}/lib/scrape/css_tags.yml")
@merchants = YAML.load_file("#{Rails.root}/lib/scrape/merchants.yml")

def self.get_data merchant
shop = @merchants[merchant]	
page = @agent.get shop['url']

page.css(@tags[merchant]['product']).each do |item|
 r = Retailer.new
 r.merchant = merchant
 r.price = item.at_css(@tags[merchant]['price']).text.match(/\d+/)[0].to_f
 r.s_price = item.at_css(@tags[merchant]['s_price']).text.match(/[\d,]+/)[0].to_f unless item.at_css(@tags[merchant]['s_price']).nil?
 r.title = item.at_css(@tags[merchant]['title']).text 
 r.picture_url = item.at_css(@tags[merchant]['picture'])['src']
 #product page link and description on that page 
 r.link = item.at_css(@tags[merchant]['link'])['href']
 # r.description = Mechanize::Page::Link.new(item.at_css(@tags[merchant]['link']),@agent,page).click.css(@tags[merchant]['desc']).text
 r.save!
end	
page
end	


end