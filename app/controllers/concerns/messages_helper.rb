module MessagesHelper
  require 'net/https'
  require "uri"

  def find_poll_addr(message_addr)
  	# m_request_id = Message.find_by(request_id: m_request_id)
    ## below are referenced from http://www.rubyinside.com/nethttp-cheat-sheet-2940.html\

    # Request.find_by(m_request_id).address
	uri = URI.parse('https://www.googleapis.com/civicinfo/v2/voterinfo?address=' + \
		message_addr + '&electionId=2000&key=' + ENV["GOOGLE_API_KEY"])
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


# create_table "messages", force: :cascade do |t|
#     t.string   "body"
#     t.integer  "request_id"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["request_id"], name: "index_messages_on_request_id", using: :btree
#   end

#   create_table "requests", force: :cascade do |t|
#     t.string   "phone"
#     t.string   "address"
#     t.string   "poll"
#     t.string   "desc"
#     t.integer  "responder_id"
#     t.datetime "created_at",   null: false
#     t.datetime "updated_at",   null: false
#     t.integer  "status"
#     t.integer  "issue"
#     t.index ["responder_id"], name: "index_requests_on_responder_id", using: :btree
#   end