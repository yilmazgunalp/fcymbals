module RetailersHelper
puts Rails.root
@@log_file = File.new("#{Rails.root}/log/scrape_log.txt")

def self.log_file 
@@log_file
end	


$models = YAML.load_file("#{Rails.root}/db/models.yml")


$brands = ["istanbul","paiste","sabian"]
$types = ["china","crash", "hi hat" ]

def get_match  array, text

array.each do |item|

return item if text.downcase.match("#{item}\s")

end
nil
end	



end
