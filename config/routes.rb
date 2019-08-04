Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :games, only: [:create]
      resources :characters, only: [:show]
      resources :quotes, only: [:show]
      get '/profile', to: 'users#profile'
      post '/signin', to: 'auth#create'
    end
  end
end