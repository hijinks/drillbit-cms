Drillbit::Engine.routes.draw do

	resources :users, :user_sessions, :sites
	
	get 'login' => 'user_sessions#new', :as => :login
	get 'logout' => 'user_sessions#destroy', :as => :logout
	put 'update_profile' => 'profiles#update', :as => :update_profile
	get 'profile' => 'profiles#show', :as => :show_profile
	get 'nginx_upload' => 'images#create'
	
	resources :users do
		member do
			get :activate
		end
		
		resource :profile
	end
	
	resources :sites do
		resources :posts
	end

	resources :galleries
	
	resources :posts do 
		resources :galleries
	end
	
	resources :images, only: [:new, :create]
	
	resources :galleries do
		resources :images, only: [:new, :create]
	end
		
	root :to => 'welcome#index', :as => :landing
end
