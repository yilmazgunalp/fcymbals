class Retailer < ApplicationRecord
	include Productmatch
	include Solr
  	belongs_to :maker, :inverse_of => :retailers

	def self.alloc(merchant,res=nil,rec=nil,log = false)
		@rsp =  if(rec == 'all') 
				Solr.match(Retailer.where(merchant: merchant)) 
			else	
				Solr.match(Retailer.where(merchant: merchant, maker_id: 3604))
			end #if	
			
		@rsp.each do |k,v|
			if v.length == 1 || (!v.empty? && v[0]['score'] - v[1]['score'] > 1)
			Maker.find(v[0]["id"]).retailers << k
			@rsp.delete(k) unless res == "all"
			end#if
		end	#rsp.each
		log_allocate(@rsp) if log
		@rsp 
	end #allocate   

	def self.csv_import file
		log_file = File.new("#{Rails.root}/log/Retailer_Update_log.txt","w")
		File.open(log_file,"a+")
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
		new_price != price ? update(price: new_price) : touch
	end #check_price

	def self.deactivate_records merchant,time
		Retailer.where("merchant = ? AND updated_at < ?",merchant,time).each {|retailer| retailer.update(active: false)}
	end	# deactivate_records

	def to_log
		id.to_s + "\t" + title + "\t" + "\t\tACTIVE:\t" +active.to_s
	end #to_log

	
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


	def self.log_allocate(match_hash)
		match_hash.each do |k,v|
			Solr::MATCH_LOG_FILE.puts("______________________________________________________________________________")
			Solr::MATCH_LOG_FILE.puts(k.to_log)
			Solr::MATCH_LOG_FILE.puts("..............................................................................")
			v.empty? ? Solr::MATCH_LOG_FILE.puts("..NO MATCH FOUND!...") : log_matches(v)
			Solr::MATCH_LOG_FILE.puts("______________________________________________________________________________")
			Solr::MATCH_LOG_FILE.puts
		end #match_hash.each

		Solr::MATCH_LOG_FILE.flush
	end #log_allocate()	

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

	def log_no_brand(e)
		Productmatch::NO_BRANDS.puts "#{id} : #{title}"
		Productmatch::NO_BRANDS.puts "#{e}  : #{e.h}"
		Productmatch::NO_BRANDS.puts 
		Productmatch::NO_BRANDS.flush
	end #log_no_brand	

	def self.log_matches(results_ary)
		results_ary.each do |record|
			Solr::MATCH_LOG_FILE.write("id: " + record['id'].to_s + "\t" )
			Solr::MATCH_LOG_FILE.write("brand: " + record['brand'].to_s + "\t\t" )
			Solr::MATCH_LOG_FILE.write("series: " + record['series'].to_s + "\t\t\t\t" )
			Solr::MATCH_LOG_FILE.write("model: " + record['model'].to_s + "\t\t\t" )
			Solr::MATCH_LOG_FILE.write("kind: " + record['kind'].to_s + "\t\t" )
			Solr::MATCH_LOG_FILE.write("size: " + record['size'].to_s + "\t\t" )
			Solr::MATCH_LOG_FILE.write("score: " + record['score'].to_s + "\t\t" )
			Solr::MATCH_LOG_FILE.puts
		end
	end#self.log_matches

end # Retailer