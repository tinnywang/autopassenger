class PassengerInformation

  URL = 'http://www.southwest.com/flight/retrieveCheckinDoc.html'
  DATE_FORMAT = '%m/%d/%Y'
  DAYS = [Time.now.strftime(DATE_FORMAT), (Time.now + 1.day).strftime(DATE_FORMAT)]
  TIME_ZONES = ActiveSupport::TimeZone.us_zones.select { |zone| zone =~ /\(US & Canada\)|Alaska|Hawaii/ }

  attr_accessor :first_name, :last_name, :confirmation_number, :check_in_time, :email

  def initialize(passenger_info)
    if !passenger_info.blank?
      @first_name = passenger_info[:first_name]
      @last_name = passenger_info[:last_name]
      @confirmation_number = passenger_info[:confirmation_number]
      date = passenger_info[:date].split('/')
      time = passenger_info[:time].match('(?<hour>\d{1,2})\:(?<minute>\d{1,2})\ (?<meridian>\S{2})')
      zone = passenger_info[:zone].match('(.?\d+:\d{2})')[0]
      if time[:meridian].downcase == 'pm'
        hour = time[:hour].to_i + 12
      end
      @check_in_time = Time.new(date[2], date[0], date[1], hour, time[:minute], 0, zone).utc
      #@check_in_time = Time.local(date[2], date[0], date[1], hour, time[:minute])
      @email = passenger_info[:email]
    end
  end

  def check_in
    BoardingPassMailer.boarding_pass(self, 'fake url').deliver
    #mech = Mechanize.new
    #mech.get(URL) do |page|
      # poll until we successfully check-in
      #begin
        #result = page.form_with(:id => 'itineraryLookup') do |form|
          #form.confirmationNumber = @confirmation_number
          #form.firstName = @first_name
          #form.lastName = @last_name
        #end.submit
      #end while result.at('#printDocumentsButton').blank?
      #mech.page.form_with(:id => 'checkinOptions') do |form|
        #form.click_button(form.button_with(:id => 'printDocumentsButton'))
      #end
      # email the boarding pass
      #url = mech.page.uri.to_s
      #BoardingPassMailer.boarding_pass(self, url).deliver
    #end
  end
  handle_asynchronously :check_in, :run_at => Proc.new { |info| info.run_at }

  def run_at
    if @check_in_time - Time.now.utc > 30
      return @check_in_time - 30
    else
      return Time.now.utc
    end
  end
end
