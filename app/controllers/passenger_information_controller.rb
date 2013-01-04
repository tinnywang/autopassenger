class PassengerInformationController < ApplicationController

  def index
  end

  def check_in
    passenger_info = params[:passenger_info]
    flash[:error] = ''
    passenger_info.keys.each do |field|
      flash[:error] += ', ' + field.gsub('_', ' ') if passenger_info[field].blank?
    end
    if not flash[:error].blank?
      flash[:error] = 'You left the following fields blank: ' + flash[:error][2..-1] + '.'
    else
      passenger_info = PassengerInformation.new(passenger_info)
      spawn_block :method => :fork, :kill => false do
        passenger_info.check_in
      end
      flash[:notice] = "We'll check you in and email your boarding pass to you. Refresh or leave this page at your leisure!"
    end  
  redirect_to root_path
  end
end
