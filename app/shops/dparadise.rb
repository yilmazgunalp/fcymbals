class Dparadise < Shop


@merchant = "dparadise"
@shop = Scraper.merchants[@merchant]	
@page = Scraper.agent.get shop['url']


@options = {
pic_url: ->(item,selector) {item.previous_element.at_css(selector)['src']},
title: -> (item,selector) {item.at_css(selector)['href'].match(/\/(([^\/])+$)/)[1].gsub("-"," ")}
}


def self.scrape 
get_all_links(page).each {|link| extract_data(get_page(link))}
@file.flush.close
@file.to_io
end #scrape()


def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end # extract_data

def self.get_page link
Scraper.agent.get link
end # get_page

def self.get_all_links first_page
all_links = []
get_main_links(first_page).each do |main_link|
get_list_of_links(main_link).each {|l| all_links << l}			
end
all_links
end # get_all_links

def self.get_list_of_links  main_link
links =[]
get_page(main_link).css('td.contentTableCell > p[align="center"]>a[href^="/cymbal-catalog"]').each do |element|	
links << URI.parse(shop['url']) + element['href']
end
links
end # get_list_of_links  

def self.get_main_links first_page
main_links = []
first_page.css('a[href^="/cymbals/"]','a[href^="/cymbal-catalog/"]').each do |element|
main_links << URI.parse(shop['url']) + element['href']
end
main_links
end # get_main_links

def self.prepare_file 
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w") 
@file = CSV.open(new_file,'a+',:quote_char => '\'')	
file <<  ["title","price","s_price","picture_url","merchant","link"]
end	# prepare file

end #class Dparadise

