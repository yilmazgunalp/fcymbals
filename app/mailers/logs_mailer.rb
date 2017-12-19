class LogsMailer < ApplicationMailer
	default from: 'logs@fcymbals.com'
  def log_email file 
  	attachments['scrap.TXT'] = File.read(file)
    mail(to: 'yilmazgunalp@gmail.com' , subject: 'I come from the dark automated')
  end

end
