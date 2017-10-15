module RetailersHelper

$log_file = File.new("#{Rails.root}/log/scrape_log.txt")
$models = YAML.load_file("#{Rails.root}/db/models.yml")
$brands = $models.keys
$types = Maker.select(:kind).distinct.map {|m| m.kind}
$sizes = YAML.load_file("#{Rails.root}/db/sizes.yml")


def get_match  array, text
 last_word = text.match(/(\w+)?\s$/)[1]
 	if array 
	array.each do |item|
	return item if text.downcase.match("#{item}\s")
	end
	"null"
	else
	"null"	
	end	
end	


def self.set_default_proc hash
 hash.default_proc = Proc.new {|hash,k| hash[k] = Hash.new({}) }  
	hash.values.each do |key|
		if key.instance_of?(Hash) 
		set_default_proc key
		end
	end
end

set_default_proc $models
set_default_proc $sizes

end


