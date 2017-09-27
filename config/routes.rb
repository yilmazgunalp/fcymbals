Rails.application.routes.draw do

	root 'makers#index'	
  get 'makers/index'

  get 'retailers/scrape_gh'
  get 'retailers/index'

end
