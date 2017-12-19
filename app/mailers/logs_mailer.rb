class LogsMailer < ApplicationMailer
	default from: 'logs@fcymbals.com'
  def log_email
  	puts "inside mail"
      mail(to: 'yilmazgunalp@gmail.com' , subject: 'I come from the dark')
  end

end
