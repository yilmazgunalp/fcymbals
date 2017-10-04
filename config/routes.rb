Rails.application.routes.draw do

	root 'makers#index'	
  get 'makers/index'

  get 'retailers/scrape'
  get 'retailers', to: 'retailers#index' 

end
