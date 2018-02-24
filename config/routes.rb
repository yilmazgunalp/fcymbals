Rails.application.routes.draw do

  root 'makers#index'	
  get 'makers/index'

  get 'retailers/allocate'
  get 'retailers', to: 'retailers#index' 

  resources :makers

require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

mount Resque::Server, at: '/jobs'  


end
