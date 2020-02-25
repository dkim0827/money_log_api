Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # route to check current_user
      get 'users/current', to: 'users#current'
      # route to change password
      patch '/users/:id/password_update', to: 'users#password_update'

      resource :session, only: [:create, :destroy]
      resources :users
      resources :statements do
        resources :transactions
      end
    end
  end
end
