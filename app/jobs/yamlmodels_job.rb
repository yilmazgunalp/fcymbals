class YamlmodelsJob
include Productmatch	
 
def self.queue
    :yaml
  end	

  def self.perform 
    brands = Maker.select(:brand).distinct.map {|m| m.brand}
# # Brand > Series > Model mapping
File.open("#{Rails.root}/lib/allocate/models.yml", "w").rewind
file = File.open("#{Rails.root}/lib/allocate/models.yml", "a+")
data = {}	
brands.each do |brand|
	data[brand] = Maker.where(brand: brand).select(:model).distinct.map {|m| m.model}
end	
file.write(data.to_yaml)
file.flush
end
end