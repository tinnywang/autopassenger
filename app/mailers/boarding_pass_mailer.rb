class BoardingPassMailer < ActionMailer::Base
  def boarding_pass(passenger_info, url)
    @passenger_info = passenger_info
    @url = url
    mail(
      :from => 'no-reply@autopassenger.herokuapp.com',
      :to => passenger_info.email,
      :subject => 'Your Boarding Pass'
    )
  end
end
