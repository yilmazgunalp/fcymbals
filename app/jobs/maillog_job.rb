class MaillogJob
 
def self.queue
    :logmail
  end	

  def self.perform path_to_file,merchant,action
    LogsMailer.log_email(path_to_file,merchant,action).deliver
  end
end