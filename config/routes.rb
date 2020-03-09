Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, :only => [:show, :create, :update, :index] do
        post 'check_answer', on: :collection
      end
      resources :characters, :only => [:index, :show]
      resources :quotes, :only => [:show]
      
      get '/validate_token', :to => 'users#validate_token'
      post '/signup', :to => 'users#signup'
      post '/signin', :to => 'users#signin'
      get '/email_confirmation', :to => 'users#email_confirmation'
    end
  end
end