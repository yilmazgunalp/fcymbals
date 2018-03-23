class LogsMailer < ApplicationMailer
	default from: 'logs@fcymbals.com'
  def log_email path_to_file,merchant,action
  	attachments["#{action}_#{merchant.upcase}.txt"] = File.read(path_to_file)
    mail(to: 'yilmazgunalp@gmail.com' , subject: "#{merchant} #{action.to_s}")
rescue => e 
	p e
  end

end
