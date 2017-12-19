class MaillogJob
 
def self.queue
    :logmail
  end	

  def self.perform file
    LogsMailer.log_email(file).deliver
  end
end