Resque::Server.use(Rack::Auth::Basic) do |user,password|

password = ENV["RESQUE_WEB_PSWD"]

end	

Resque.logger.formatter = Resque::VeryVerboseFormatter.new
Resque.logger.level = Logger::DEBUG

Resque.schedule = YAML.load_file("#{Rails.root}/app/jobs/_schedule.yml")
