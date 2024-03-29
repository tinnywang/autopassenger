class PassengerInformation

  URL = 'http://www.southwest.com/flight/retrieveCheckinDoc.html'
  DATE_FORMAT = '%m/%d/%Y'
  DAYS = [Time.now.strftime(DATE_FORMAT), (Time.now + 1.day).strftime(DATE_FORMAT)]
  TIME_ZONES = {}
  ActiveSupport::TimeZone.us_zones.each do |zone|
    zone = zone.to_s
    index = zone =~ /\s\(US & Canada\)/
    if index
      matches = zone.match('\(\w*(?<offset>.?\d+:\d{2})\)\s(?<zone>.*)\s\(US & Canada\)')
      TIME_ZONES[matches[:zone]] = matches[:offset]
    else
      matches = zone.match('\(\w*(?<offset>.?\d+:\d{2})\)\s(?<zone>.*)')
      TIME_ZONES[matches[:zone]] = matches[:offset]
    end
  end

  attr_accessor :first_name, :last_name, :confirmation_number, :check_in_time, :email

  def initialize(passenger_info)
    if !passenger_info.blank?
      @first_name = passenger_info[:first_name]
      @last_name = passenger_info[:last_name]
      @confirmation_number = passenger_info[:confirmation_number]
      date = passenger_info[:date].split('/')
      time = passenger_info[:time].match('(?<hour>\d{1,2})\:(?<minute>\d{1,2})\ (?<meridian>\S{2})')
      zone = TIME_ZONES[passenger_info[:zone]]
      if time[:meridian].downcase == 'pm'
        hour = time[:hour].to_i + 12
      else
        hour = time[:hour]
      end
      @check_in_time = Time.new(date[2], date[0], date[1], hour, time[:minute], 0, zone).utc
      @email = passenger_info[:email]
    end
  end

  def check_in
    mech = Mechanize.new
    mech.get(URL) do |page|
      sleep_time = @check_in_time - Time.now.utc
      if sleep_time > 30
        sleep(sleep_time)
      end
      begin
        result = page.form_with(:id => 'itineraryLookup') do |form|
          form.confirmationNumber = @confirmation_number
          form.firstName = @first_name
          form.lastName = @last_name
        end.submit
      end while result.at('#printDocumentsButton').blank?
      mech.page.form_with(:id => 'checkinOptions') do |form|
        form.click_button(form.button_with(:id => 'printDocumentsButton'))
      end
      url = mech.page.uri.to_s
      BoardingPassMailer.boarding_pass(self, url).deliver
    end
  end
end
