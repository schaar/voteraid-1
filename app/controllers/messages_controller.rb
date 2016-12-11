class MessagesController < ApplicationController 
 skip_before_filter :verify_authenticity_token
 #skip_before_filter :authenticate_user!, :only => "reply"
  require 'net/http'
  require 'json'
  include MessagesHelper

  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :secret => ENV["SECRET_KEY_BASE"]

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    @responder = Responder.find_by phone: from_number 
    if session["request_id"].nil? && @responder.nil?
      @req = Request.create!({phone: from_number, status: 1, responder_id: nil})
      @message = @req.messages.create({body: message_body})
    else
      if @responder
        @req = Request.last
        puts "Responder reply"
      else
        @req = Request.find(session["request_id"])
      end
      @message = @req.messages.create({body: message_body})
    end
    session["request_id"] = @req.id
    boot_twilio
    @nearby = nil
    # when reply, test to return the nearest polling address
    if @req.status == 5
      @body, @nearby = handle_help_request(@req, @message)
    elsif @responder and /Y(es)?/i.match(message_body)
      @body = handle_responder(@req, @responder.id)
    else
      @body = handler(@req, @message)
    end
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: @body
    )
    if @nearby
      from = ENV["TWILIO_NUMBER"]
      issue = index_to_issue(@req.issue)
      @nearby.each do |person|
        session["request_id"] = @req.id
        session["responder_id"] = person.id
        @client.account.messages.create(
          :from => from,
          :to => person.phone,
          :body => "Hi, someone near #{@req.address} needs your help. The voter is experiencing this issue: " + issue +  "\nThey have described the issue as: #{@req.desc}. Please repond with Yes if you are able to help."
        )
        puts "Sent request for help to #{person.fname}"
      end
    end
  end

  private

  def boot_twilio
    @client = Twilio::REST::Client.new(ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"])
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

end
