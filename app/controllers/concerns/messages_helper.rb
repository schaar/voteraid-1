module MessagesHelper
  require 'net/https'
  require "uri"

  require 'rubygems'
  require 'twilio-ruby'

  def handler(req, message)
    puts "Incoming request status : #{req.status} - #{message.body}"
    case req.status
    when 1
      req.update_attribute(:status, req.status + 1)
      return "Welcome to VoterAid. What's your address of registration?\n Please respond with full street address, city and state."
    when 2 # User responds with location
      return record_address_ask_issue(req, message)
    when 3 # User responds with issue"
      return record_issue_ask_need_responder(req, message)
    when 4
      if message.body == "no" || message.body == "No"
        req.update_attribute(:status, 9)
        return "Congratulations! Your case has been resolved"
      else
        req.update_attribute(:status, req.status + 1)
        return "Could you provide a detailed description?"
      end
    when 6
      return "Please wait. We are still matching your request up."
      # return "waiting 30 minutes"
    when 7
      ## ToDo: set listener to hear responder's feedback
      req.update_attribute(:status, req.status + 1)
      reject_other_respondents(req, message)
      confirm_respondent(req, message)
      confirm_requester(req, message)
    when 8 # already contact requestor "Let us know it has been resolved or not?"
      if message == "yes" || message == "Yes"
        req.update_attribute(:status, 9)
        return "Congratulations! Your case has been resolved"
      else
        req.update_attribute(:status, 10)
        return "We are sorry that we are unavailable to solve the issue right now"
      end
    end
  end

  def handle_help_request(req, message)
      req.update_attribute(:desc, message.body)
      finding = find_nearby_responders(req, message)
      if finding.count(:all) > 0
        req.update_attribute(:status, req.status+1)
        return "Connecting to responders. We appreciate your patience" ,finding
      else
        req.update_attribute(:status, 10)
        return "We are sorry, no body is available to assist right now", finding
      end
  end   

  def record_address_ask_issue(req, message)
    req.update_attributes({address: message.body, status: req.status + 1})
    text = "Thank you. What is your issue?\n1.Problem with ID\n2.Name not on registration list\n3.Eligibility to vote was challenged\n4.Can't check in at the poll\n5.Problem with voting machine\n6.Line to vote is too long\n7.Problem with provisional ballot\n8.Other"
    return text
  end

  def record_issue_ask_need_responder(req, message)
    num = message.body.to_i
    if (num>0 && num < 9)
      if (num == 6) #voting line too long
        info = find_poll_addr(req.address)
      end
      info = info || ""
      req.update_attributes({issue: num, status: req.status+1})
      return info + "Do you need to be connected to a responder?"
    else
      ## DO NOT INCREMENT STATE
      return "Sorry, invalid input. Please reply with the number code of your issue"
    end
  end

  def find_nearby_responders(req, message)
    # ToDo: Add logic to find responders
    responders = Responder.near(req.address, 50).limit(5)
    return responders
  end

  def handle_responder(req,responder_id)
      if confirm_respondent(req, responder_id)
        req.update_attributes({status: req.status + 1, responder_id: responder_id})
        send_confirm_to_requester(req)
        return "Thank you for helping. P..."
      else 
        return "Thank you for offering your assistance. Someone else has already been assigned to this request."  
      end
  end

  def confirm_respondent(req, responder_id)
   # check that respondent exist and request status is 6
    if req.status != 6
      return false
    end
    return !Responder.find(responder_id).nil?
  end

  def index_to_issue(index) 
    case index
    when 1
      return "Problem with ID"
    when 2
      return "Name not on registration list"
    when 3
      return "Eligibility to vote was challenged"
    when 4
      return "Cannot check in at the poll"
    when 5
      return "Problem with voting machine"
    when 6
      return "Line to vote is too long"
    when 7
      return "Problem with provisional ballot"
    when 8
      return "Other"
    end
  end

  def send_confirm_to_requester(req)
    @client = Twilio::REST::Client.new(ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"])
    from = ENV["TWILIO_NUMBER"] 
    responder = req.responder
    client.account.messages.create(
      :from => from,
      :to => req.phone,
      :body => "Congratulations! We find someone who could assist you. His/Her name \
      is #{responder.fname} + #{responder.lname} and phone number is: #{responder.phone} "
    )
    puts "Sent message to #{value}"
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
