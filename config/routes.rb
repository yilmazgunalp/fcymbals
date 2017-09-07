Rails.application.routes.draw do

	root 'makers#index'	
  get 'makers/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
