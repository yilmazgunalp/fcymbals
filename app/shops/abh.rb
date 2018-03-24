class Abh < Shop


@merchant = "abh"
@shop = Scraper::MERCHANTS[merchant]
@page = get_page(shop['url'])
@form = page.form_with(:dom_id => "aspnetForm")

@options = {
code:  -> (page,selector) {page.at_css(selector).text.match(/Code:\s+.(\w+)/)[1]}
}


def self.get_list_of_links  node_set
links = node_set.map {|e|  e['id']}
end

def self.get_node_sets first_page
node_sets = []
page = first_page
	while !page.at_css("a#MainContent_pdlAllProducts_dlProductList_LinkButtonNext").nil?
	node_set = page.at_css("td#MainContent_pdlAllProducts_dlProductList_tdLinks").css("a[id^='MainContent_pdlAllProducts_dlProductList_LinkButton']")
	node_sets << node_set
	next_link = get_list_of_links(node_set)[-2]
	page = get_asp_page next_link
	end
node_sets
end

def self.get_all_links first_page
links = []
get_node_sets(first_page).each do |node_set|
get_list_of_links(node_set).each {|l| links << l}			
end
links.uniq
end

def self.get_asp_page link
link_for_form = "ctl00:" + link.gsub("_",":").gsub("LinkButton","ctl00:LinkButton")
form['__EVENTTARGET'] = link_for_form
form['RadAJAXControlID'] = "MainContent_RadAjaxPanel1"
Nokogiri::HTML(File.open(form.submit.save!("#{Rails.root}/tmp/scrape/#{merchant}.html")))
end


def self.scrape
prepare_file	
get_all_links(page).each {|link| eval("extract_data(get_asp_page(link))")}
@file.flush.close
@file.to_io
end


end #class Abh	

