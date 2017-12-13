require_relative 'boot'
puts "Starting with a difference!..."
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fcymbals
  class Application < Rails::Application
  	config.autoload_paths += %W(#{config.root}/lib/scrape)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :resque
    config.time_zone = 'Sydney'

 #    config.after_initialize do
 #    fork do	
 #  	Resque.schedule = YAML.load_file("#{Rails.root}/app/jobs/_schedule.yml")
	# Resque::Scheduler.run
	# end #fork	
	# end #after_initialize
    
    
    end #class Application
end #Module Fcymbals
