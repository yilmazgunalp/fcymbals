class LogsMailer < ApplicationMailer
	default from: 'logs@fcymbals.com', to: 'yilmazgunalp@gmail.com'
 
  def self.log_email
  	puts "inside mail"
      mail(subject: 'I come from the dark')
  end

end
