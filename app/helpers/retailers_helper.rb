module RetailersHelper

$models = YAML.load_file("#{Rails.root}/db/models.yml")
$brands = $models.keys
$types = Maker.select(:kind).distinct.map {|m| m.kind}
$types.delete_at($types.index("crash ride"))
$types.unshift("crash ride")
$types.delete_at($types.index("flat ride"))
$types.unshift("flat ride")
$sizes = YAML.load_file("#{Rails.root}/db/sizes.yml")
$vars = YAML.load_file("#{Rails.root}/db/vars.yml")


def get_match  array, text, *args
  	if array 
	array.each do |item|
	return item if text.downcase.match("#{item}\s")
	end
  	if args[0] &&  $vars[args[-1]]
  	  if args[0] == :series || args[0] == :mis
  	  	cleaned_text = text 
  	    $vars[args[-1]][args[0].to_s].values.each do |values_array|
  	    	values_array.each do |value|	
	  	    if text.downcase.match("#{value}\s")
	  	    	cleaned_text = cleaned_text.downcase.sub(value,$vars[args[0].to_s].key(values_array))
	    	end
	  	    end
  		end
  		p cleaned_text
  		array.each do |item|
		return item if cleaned_text.downcase.match("#{item}\s")
		end

  	  end
  	  	if args[0] == :type
  	  		$vars[args[0].to_s].values.each do |v|
	  	   	if v.any?{|sv| text.downcase.match("#{sv}\s")}
	        return $vars[args[0].to_s].key(v)
	        end  
	    	end
    	end
  	end  
	"null"
	else
	"null"	
	end	
end	


def update_maker retailer,maker,logs
if maker.retailers.where(merchant: retailer.merchant).empty?
retailer.update(maker: maker)	
else
logs.write "DUPLICATE =>\t" + "with: " + maker.retailers.where(merchant: retailer.merchant).first.id.to_s + "\n"	
logs.write("Retailer: " + retailer.id.to_s + retailer.title + " : is a duplicate match \n")
logs.write("Maker: " + maker.id.to_s + " " + maker.code.to_s + ": is already matched with " + maker.retailers.where(merchant: retailer.merchant).first.title+"\n")
logs.write ">>>>>>>>>>>>>>>>>\n"
return nil		
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


