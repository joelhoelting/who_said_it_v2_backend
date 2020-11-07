Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, :only => [:show, :create, :update, :index] do
        post 'check_answer', on: :collection
      end
      resources :characters, :only => [:index, :show]
      resources :quotes, :only => [:show]
      
      # Authentication
      get '/validate_token', :to => 'users#validate_token'
      post '/sign_up', :to => 'users#sign_up'
      post '/confirm_email', :to => 'users#confirm_email'
      post '/resend_confirmation_email', :to => 'users#resend_confirmation_email'
      post '/sign_in', :to => 'users#sign_in'
      get '/delete_account', :to => 'users#delete_account'
      post '/request_password_reset', :to => 'users#request_password_reset'
      get '/confirm_password_reset_token/:password_reset_token', :to => 'users#confirm_password_reset_token'
      post '/reset_password', :to => 'users#reset_password'
      post '/update_password', :to => 'users#update_password'
    end
  end
end