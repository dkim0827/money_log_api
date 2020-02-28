Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # route to check current_user
      get 'users/current', to: 'users#current'
      # route to change password
      patch '/users/:id/password_update', to: 'users#password_update'
      
      resource :session, only: [:create, :destroy]
      resources :users, only: [:create, :update, :destroy]
      
      resources :statements, only: [:index, :create, :show, :update, :destroy] do
        resources :transactions, only: [:create, :update, :destroy]
      end

    end
  end
end
