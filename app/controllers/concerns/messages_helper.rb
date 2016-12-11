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
      if /n(o)?/i =~ message.body 
        req.update_attribute(:status, 9)
        return "Congratulations! Your case has been resolved"
      else
        req.update_attribute(:status, req.status + 1)
        return "Could you provide a detailed description?"
      end
    when 6
      return "Thanks for waiting. We are in the process of finding someone."
    when 8 # already contact requestor "Let us know it has been resolved or not?"
      if  /y(es)?/i =~ message.body 
        req.update_attribute(:status, 9)
        return "Congratulations! Your case has been resolved"
      else
        req.update_attribute(:status, 10)
        return "We are sorry that we are unavailable to solve the issue right now"
      end
    end
  end

  # status 2
  def record_address_ask_issue(req, message)
    req.update_attributes({address: message.body, status: req.status + 1})
    text = "What do you need help with?\n1.Problem with ID\n2.Name not on registration list\n3.Eligibility to vote was challenged\n4.Can't check in at the poll\n5.Problem with voting machine\n6.Line to vote is too long\n7.Problem with provisional ballot\n8.Other"
    return text
  end

  # status 3
  def record_issue_ask_need_responder(req, message)
    num = message.body.to_i
    if (num>0 && num < 9)
      if (num == 6) #voting line too long
        info = find_poll_addr(req.address)
      end
      info = info || ""
      req.update_attributes({issue: num, status: req.status+1})
      return info + "Would you like to be connected to a responder?"
    else
      return "Sorry, we receive invalid input. Please reply with the number code of your issue."
    end
  end

  # helper func in status 3
  def find_poll_addr(message_addr)
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

  # status 5 
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

  # helper status 5 
  def find_nearby_responders(req, message)
    # ToDo: Add logic to find responders
    responders = Responder.near(req.address, 50).limit(5)
    return responders
  end
 
  # status 6
  def handle_responder(req,responder_id)
      if confirm_respondent(req, responder_id)
        req.update_attributes({status: req.status + 1, responder_id: responder_id})
        send_confirm_to_requester(req)
        return "Thank you for helping. PLease go to the location & meet up with the requester."
      else 
        return "Thank you for offering your assistance. Someone else has already been assigned to this request."  
      end
  end

  # helper status 6
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
  end

  # helper status 6
  def confirm_respondent(req, responder_id)
   # check that respondent exist and request status is 6
    if req.status != 6
      return false
    end
    return !Responder.find(responder_id).nil?
  end

  


end
