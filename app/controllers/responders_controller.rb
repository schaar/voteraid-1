class RespondersController < ApplicationController
  def new
    @responder = Responder.new
    render :new
  end

  def create
    @responder = Responder.new(params[:responder])
  end
end
