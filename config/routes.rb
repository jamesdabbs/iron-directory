Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: :auth }
  devise_scope :user do
    get    '/login'  => 'auth#login',  as: :new_user_session
    delete '/logout' => 'auth#logout', as: :destroy_user_session
  end

  resource :profile, only: [:show]

  resources :teams, only: [:index, :show, :edit, :update]

  post '/slack/sync' => 'teams#sync', as: :sync_slack
  patch '/profile/api_key' => 'profiles#reset_api_key', as: :reset_api_key

  root to: 'teams#staff'
end
