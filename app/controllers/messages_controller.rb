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
    if session["request_id"].nil?
      @req = Request.create!({phone: from_number, status: 1, responder_id: nil})
      @message = @req.messages.create({body: message_body})
    else
      @req = Request.find(session["request_id"])
      if session['responder_id'] and /Y(es)?/.match(message_body)
        @message = handle_responder(@req, session['responder_id'])
      else
        @message = @req.messages.create({body: message_body})
      end
    end
    session["request_id"] = @req.id
    boot_twilio
    # when reply, test to return the nearest polling address
    @body = handler(@req, @message)
    poll_addr = find_poll_addr("2020 kittredge street")
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: "Request ID: #{@req.id}. Your number is #{from_number}. \
         #{@body}"
    )
    
  end

  private

  def boot_twilio
    @client = Twilio::REST::Client.new(ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"])
  end



end
