module RetailersHelper

$log_file = File.new("#{Rails.root}/log/scrape_log.txt")
$models = YAML.load_file("#{Rails.root}/db/models.yml")
$brands = $models.keys
$types = Maker.select(:kind).distinct.map {|m| m.kind}

def get_match  array, text
	array.each do |item|
	return item if text.downcase.match("#{item}\s")
	end
	nil
end	



end
