class MessagesController < ApplicationController 
 skip_before_filter :verify_authenticity_token
 #skip_before_filter :authenticate_user!, :only => "reply"
  require 'net/http'
  require 'json'
  include MessagesHelper

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    boot_twilio
    # when reply, test to return the nearest polling address
    poll_addr = MessagesHelper.find_poll_addr("2020 kittredge street")
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: "Hello there, thanks for texting me. Your number is #{from_number}. \
            your nearest voting stationis #{poll_addr}"
    )
    
  end

  private

  def boot_twilio
    @client = Twilio::REST::Client.new(ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"])
  end



end
