require_relative 'boot'
puts "Starting with a difference!..."
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fcymbals
  class Application < Rails::Application
  	config.autoload_paths += %W(#{config.root}/lib/allocate/)
  	config.autoload_paths += %W(#{config.root}/lib/scrape/)
    config.autoload_paths += %W(#{config.root}/lib/findmatch/)
   	# Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :resque
    config.time_zone = 'Sydney'
   	#I copied this code from internet
   	config.before_configuration do
	  	env_file = File.join(Rails.root, 'config', 'local_env.yml')
	  	YAML.load(File.open(env_file)).each do |key, value|
	    ENV[key.to_s] = value
  	end if File.exists?(env_file)
end

    end #class Application
end #Module Fcymbals
