class Retailer < ApplicationRecord
	include Productmatch
  belongs_to :maker, :inverse_of => :retailers

def allocate
	puts "#{id}: #{title}"
	if code && m = Maker.find_by(code: code.downcase)
	puts "inside code"	
	m.retailers << self	
	else
	match_hash = Productmatch.match_maker(title).compact
		if match_hash.length == 5 || (match_hash.length == 4 && match_hash[:kind] == "set")
			find_maker(match_hash).retailers << self	
		else	
			raise TooManyMatchesError.new(match_hash)
		end #if	

	end #if code && m	
		rescue NoMatchError,StandardError => e 
			log_error(e)
end #allocate   

def self.csv_import file
	log_file = File.new("#{Rails.root}/log/Retailer_Update_log.txt","a+")

		CSV.foreach(file, headers: true, :quote_char => '\'',:col_sep => '~') do |row|
			begin 
			retailer =  check_for_retailer(row.field('title'), row.field('link'))
				if retailer 
				retailer.check_price(row.field('price').to_i)
				else
				Retailer.create!(row.to_h)
				end #if retailer
			rescue  StandardError => e
			puts e	
			b = binding
			log_file << "[#{File.basename(file,'.csv').upcase}]: [UPDATE]: ROW IN ERROR =>\n"	
			log_file <<  b.eval("row") 
			log_file << "[ERROR MESSAGE]: #{e.message}\n\n"
			end # rescue	
		end # CSV.foreach
	log_file.flush.close
end #csv_import	

def check_price new_price
	new_price != price ? price = new_price : touch
end #check_price

def self.deactivate_records merchant,time
	Retailer.where("merchant = ? AND updated_at < ?",merchant,time).each {|retailer| retailer.update(active: false)}
end	# deactivate_records

def to_log
	id.to_s + "\t" + title + "\t" + active.to_s
end #to_log

class NoMatchError < StandardError
	attr_accessor :h
	def initialize(hash)
		@h = hash
	end		
end

class TooManyMatchesError < NoMatchError
end	

private

def self.check_for_retailer title,link
	result = Retailer.where(title: title, link: link)
	result.length == 1 ? result.first : false
end	# check_for_retailer

def find_maker(hash) 
Maker.find_by!(hash)
rescue ActiveRecord::RecordNotFound
raise NoMatchError.new(hash)
end	

def find_makers(hash,n=3) 
Maker.where(hash).take(n)
end	

def log_error(e)
	Productmatch::LOG_FILE.puts "#{id} : #{title}"
	Productmatch::LOG_FILE.puts "#{e}  : #{e.h}"
	Productmatch::LOG_FILE.puts  e.cause.class unless e.instance_of?(TooManyMatchesError)
	if e.instance_of?(TooManyMatchesError)
			Productmatch::LOG_FILE.puts "#{find_makers(e.h,50000).length} many possible matches"
			find_makers(e.h).each_with_index do |e,i|
				Productmatch::LOG_FILE.puts "#{i+1}: #{e.to_hash}"
			end #each 
	end #if
	Productmatch::LOG_FILE.puts 
	Productmatch::LOG_FILE.flush
end #to_log

end # Retailer