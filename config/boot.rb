ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
####!!!!!DID NOT WORK ON UPGRADE TO 5.2 SO DISABLED IT!!!!###
#require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
