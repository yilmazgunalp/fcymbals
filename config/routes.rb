Rails.application.routes.draw do

	root 'makers#index'	
  get 'makers/index'

  get 'retailers/scrape'
  get 'retailers', to: 'retailers#index' 

require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

mount Resque::Server, at: '/jobs'  


end
