class Abh < Shop


@merchant = "abh"
@shop = Scraper.merchants[merchant]	
new_file = File.open("#{Rails.root}/db/scraped/#{merchant}.csv","w")
@file = CSV.open(new_file,'a+',:quote_char => '\'')
@page = Scraper.agent.get shop['url']
@form = page.form_with(:dom_id => "aspnetForm")

@options = {
title: ->(text){text.strip}
}

file <<  ["title","price","s_price","picture_url","merchant","link","description"]

def self.extract_data page
Scraper.csv_import(page,merchant,shop,file,options)
end


def self.get_list_of_links  node_set
links = node_set.map {|e|  e['id']}
end

def self.get_node_sets first_page,form
node_sets = []
page = first_page
	while !page.at_css("a#MainContent_pdlAllProducts_dlProductList_LinkButtonNext").nil?
	node_set = page.at_css("td#MainContent_pdlAllProducts_dlProductList_tdLinks").css("a[id^='MainContent_pdlAllProducts_dlProductList_LinkButton']")
	node_sets << node_set
	next_link = get_list_of_links(node_set)[-2]
	page = get_page next_link,form
	end
node_sets
end

def self.get_all_links first_page,form
links = []
get_node_sets(first_page,form).each do |node_set|
get_list_of_links(node_set).each{|l| links << l}			
end
links.uniq
end

def self.get_page link,form
link_for_form = "ctl00:" + link.gsub("_",":").gsub("LinkButton","ctl00:LinkButton")
form['__EVENTTARGET'] = link_for_form
form['RadAJAXControlID'] = "MainContent_RadAjaxPanel1"
Nokogiri::HTML(File.open(form.submit.save!("#{Rails.root}/tmp/scrape/#{merchant}.html")))
end


def self.scrape 
get_all_links(page,form).each {|link| extract_data(get_page(link,form))}
end



end #class Abh	

