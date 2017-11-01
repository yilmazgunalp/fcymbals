# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
# I added resque
require 'resque/tasks'
require 'resque/scheduler/tasks'
task 'resque:setup' => :environment

Rails.application.load_tasks
