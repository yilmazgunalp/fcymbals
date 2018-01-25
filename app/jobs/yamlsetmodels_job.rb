class YamlsetmodelsJob

def self.queue
    :yaml
  end	

	def self.perform 
	  	puts "inside perform "
	    brands = Maker.select(:brand).distinct.map {|m| m.brand}
		# # Brand > Series > Model mapping
		File.open("#{Rails.root}/lib/allocate/setmodels.yml", "w")
		file = File.open("#{Rails.root}/lib/allocate/setmodels.yml", "a+")

		data = {}	
		brands.each do |brand|
			data[brand] = {} 
				series = Maker.where(brand: brand).select(:series).distinct.map {|m| m.series}.sort{|a,b| b.split(" ").length <=> a.split(" ").length }
				series.each do |series|
					data[brand][series] = Maker.where(brand: brand,series: series, kind: "set" ).select(:model).map {|m| m.model}	
					data[brand].delete_if{|k,v| v.empty?}
					
				end	
		data.delete_if{|k,v| v.empty?}		
	end	
	file << (data.to_yaml)
	file.flush
	end #perform
end # class 