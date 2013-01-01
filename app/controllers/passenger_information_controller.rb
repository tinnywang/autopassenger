class PassengerInformationController < ApplicationController

  def index
  end

  def check_in
		passenger_info = PassengerInformation.new(params[:passenger_info])
    passenger_info.check_in
    flash[:notice] = "You've done your part.  We'll do the rest.  We'll check you in and email your boarding pass to you. Refresh or leave this page at your leisure!"
    redirect_to root_path
  end
end
