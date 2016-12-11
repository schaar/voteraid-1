module MessagesHelper
  require 'net/https'
  require "uri"

  def handler(req, message)
    puts "Incoming request status : #{req.status} - #{message.body}"
    case req.status
    when 1
      req.update_attribute(:status, req.status + 1)
      return "Welcome to VoterAid. What's your location?"
    when 2 # User responds with location
      return handle_address_ask_issue(req, message)
    when 3 # User responds with issue"
      return find_issue(req, message)
    when 4
      return "Do you need to be connected to a responder?"
    when 5 # If yes, connect to responders; if no, set value to resolved
      if message.body == "no" || message.body == "No"
        req.update_attribute(:status, 8)
        return "Congratulations! Your case has been resolved"
      else
        return find_responder(req.address)
      end
    when 8
      if message == "yes" || message == "Yes"
        return "Congratulations! Your case has been resolved"
      else
        return "We are sorry that we are unavailable to solve the issue right now"
      end
    end
  end

  def find_issue(req, message)
    num = message.body.to_i
    if (num>0 && num < 9)
      req.update_attributes({issue: num, status: req.status+1})
      return "Thanks"
    else
      ## DO NOT INCREMENT STATE
      return "Sorry, invalid input. Please reply with the number code of your issue"
    end
  end

  def find_responder(requester_address)
    ### LOGIC FOR FINDING RESPONDERS & NOTIFY THEM
    return "We're looking up responders near you. Please stay at your location."
  end

  def handle_address_ask_issue(req, message)

    req.update_attributes({address: message.body, status: req.status + 1})
    text = "Thank you. What is your issue?\n1.Problem with ID\n2.Name not on registration list\n3.Eligibility to vote was challenged\n4.Can't check in at the poll\n5.Problem with voting machine\n6.Line to vote is too long\n7.Problem with provisional ballot\n8.Problem with provisional ballot"
    return text
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
