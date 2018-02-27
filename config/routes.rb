Rails.application.routes.draw do

  root  to: 'searches#home'
  get 'results', to: 'searches#search'
  get 'makers/index'

  get 'retailers/allocate'
  get 'retailers', to: 'retailers#index' 

  resources :makers

require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

mount Resque::Server, at: '/jobs'  


end
