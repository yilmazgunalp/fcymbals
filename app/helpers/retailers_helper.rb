module RetailersHelper


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

end


