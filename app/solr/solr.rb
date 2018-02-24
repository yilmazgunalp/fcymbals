module Solr
	BASE_URI = 'http://localhost:8983/solr/cymbals/'

	class << self	

		def connect(retailers)
			result = {}	

			retailers.each do |r|

				rq = r.title.match("set" || "pack") ? "cymbalsets" : "allocate"
				useparams = rq == "allocate" ? "alloc" : "cymbalsets"
				uri = parse_string(rq,{q: encode_ascii(r.title), wt: 'ruby', useParams: useparams, bf: boostfunction(useparams),sow: 'true'})
				response = Net::HTTP.get_response(URI(uri))
				result[r] = eval(response.body).dig('response','docs')
			end #retailers.each	
			result
		end #connect()

		def parse_string(rq,params)
			str = ""
			params.each do |k,v|
				str += k.to_s + "=" + v.gsub(/[\"\”]/,"")+"&"	
			end	
			"#{BASE_URI}#{rq}?#{str}".chop
		end	#parse_string

		def encode_ascii(string)
			string.encode(Encoding.find('ASCII'),{invalid: :replace, undef: :replace, replace: ""})
		end	


		def boostfunction(useparams)
			if useparams === "alloc"
			return 'query({!df=\'model\'v=$q},1)^2 query({!df=\'model_exact\'v=$q},1)^2 
				query({!df=\'series_exact\'v=$q},1)^2.2 query({!df=\'kind_exact\'v=$q},1)^2.5'
			end #if	

			if useparams === "cymbalsets"
				return 'query({!df=\'series_exact\'v=$q},1)^2.2'
			end#if	
		end #boostfunction()	

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

