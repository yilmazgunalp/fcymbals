class YamlseriesJob
include Productmatch	
 
def self.queue
    :yaml
  end	

  def self.perform 
    brands = Maker.select(:brand).distinct.map {|m| m.brand}
# # Brand > Series > Model mapping
File.open("#{Rails.root}/lib/allocate/series.yml", "w").rewind
file = File.open("#{Rails.root}/lib/allocate/series.yml", "a+")
data = {}	
brands.each do |brand|
	data[brand] = {} 
	series = Maker.where(brand: brand).select(:series).distinct.map {|m| m.series}
		series.each do |series|
			data[brand][series] = Maker.where(brand: brand,series: series).select(:model).distinct.map {|m| m.model}
		end	
end	
file.write(data.to_yaml)
end
end