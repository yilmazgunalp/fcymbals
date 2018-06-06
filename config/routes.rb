Rails.application.routes.draw do

match '*path', :controller => 'application', :action => 'handle_options_request', via: :options
  root  to: 'searches#home'
  get 'results', to: 'searches#search'
  get 'makers/index'
  get 'searches/getfacets', to: 'searches#getfacets'

  get 'retailers/allocate'
  get 'retailers', to: 'retailers#index' 
  patch 'retailers/:id/linktomaker', to: 'retailers#linktomaker', as: 'linkto'

  resources :makers
  resources :retailers
require 'resque/server'
require 'resque-scheduler'
require 'resque/scheduler/server'

mount Resque::Server, at: '/jobs'  


end
