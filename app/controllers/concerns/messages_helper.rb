module MessagesHelper
  require 'net/https'
  require "uri"

  def find_poll_addr
    ## below are referenced from http://www.rubyinside.com/nethttp-cheat-sheet-2940.html
	uri = URI.parse('https://www.googleapis.com/civicinfo/v2/voterinfo?address=2020+kittredge+street&electionId=2000&key=' + ENV["GOOGLE_API_KEY"])
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	response["header-here"] # All headers are lowercase
	res_hash = JSON.parse(response.body)
    address_hash = res_hash['pollingLocations']
    # address_hash = res_hash['pollingLocations']['address']
    # locationName = address_hash['locationName']
    # line1 = address_hash['line1']
    # line2 = address_hash['line2']
    # line3 = address_hash['line3']
    puts address_hash
    # puts response.body
  end
end