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
      @req = Request.create!({phone: from_number, status: 0, responder_id: nil})
      @message = @req.messages.create({body: message_body})
    else
      @req = Request.find(session["request_id"])
      @message = @req.messages.create({body: message_body})
    end
    session["request_id"] = @req.id
    boot_twilio
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: "Hello there, thanks for texting me. Your request is #{@req.id} "
    )
    
  end

  private

  def boot_twilio
    @client = Twilio::REST::Client.new(ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"])
  end



end
