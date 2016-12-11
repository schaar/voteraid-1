module MessagesHelper
  require 'net/https'
  require "uri"

  def handler(req, message)
    case req.status 
    when 1:
      return "Welcome to Voteraid. What's your location?"
    when 2: # User responds with location
      return find_poll_addr(message) 
    when 3:
      return "What's your issue?"
    when 4: # User responds with issue"
      return find_issue(message)
    when 5:
      return "Do you need to be connected to a responder?"
    when 6: # If yes, connect to responders; if no, set value to resolved 
      if message == "no" || message == "No" 
        return "Congratulations! Your case has been resolved"
      else 
        return find_responder(req.address)
      end
    when 7:#??????????????????
      return "Responder confirms. You are connected to Responder blablabla"
    when 8:
      return "Has your issue been resolved or not?"
    when 9:
      if message == "yes" || message == "Yes"
        return "Congratulations! Your case has been resolved"
      else
        return "We are sorry that we are unavailable to solve the issue right now"
      end
    end
  end

  def find_issue(message)
    return "find issue number " + message
  end

  def find_responder(requester_address)
    return "find responder near " + requester_address
  end

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
          address_hash = res_hash['pollingLocations'][0]['address']
          locationName = address_hash['locationName']
          line1 = address_hash['line1'] || ""
          line2 = address_hash['line2'] || ""
          line3 = address_hash['line3'] || ""
          return "Your nearest voting station is: " + locationName+line1+line2+line3
    end
  end
