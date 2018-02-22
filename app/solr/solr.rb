module Solr
	BASE_URI = 'http://localhost:8983/solr/cymbals/'

	class << self	

		def connect(retailers)
			result = {}	
			retailers.each do |r|
				rq = r.title.match("set" || "pack") ? "cymbalsets" : "allocate"	
				uri = parse_string(rq,{q: r.title, wt: 'ruby'})
				response = Net::HTTP.get_response(URI(uri))
				result[r] = eval(response.body).dig('response','docs')
			end #retailers.each	
			result
		end #connect()

		def parse_string(rq,params)
			str = ""
			params.each do |k,v|
				str += k.to_s + "=" + v.gsub("\"","")+"&"	
			end	
			"#{BASE_URI}#{rq}?#{str}".chop
		end	#parse_string

		#redundant as URI can't parse properly
		def parse_uri(rq,params)
			params[:q].gsub!("\"","")
			url_string = "#{BASE_URI}#{rq}?"
			uri = URI(url_string)
			uri.query = URI.encode_www_form(params)
			uri
		end #parse_uri()

	end #self
end #module solr

