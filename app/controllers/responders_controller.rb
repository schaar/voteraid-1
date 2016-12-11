class RespondersController < ApplicationController
  def new
    @responder = Responder.new
    render :new
  end

  def create
    @responder = Responder.new(responder_params)
    if @responder.save
      flash[:success] = "Created a New Responder!"
      redirect_to root_path
    else
      flash[:error] = @responder.errors.full_messages.join(", ")
      redirect_to new_responder_path
    end
  end

  private

  def responder_params
    params.require(:responder).permit(:fname, :lname, :phone, :email, :address, :state, :zip, :barNum, :city)
  end

end
