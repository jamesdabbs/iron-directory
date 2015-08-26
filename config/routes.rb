Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: :auth }
  devise_scope :user do
    get    '/login'       => 'auth#login',  as: :new_user_session
    delete '/logout'      => 'auth#logout', as: :destroy_user_session

    post '/login/email'        => 'auth#send_ios_login_email', as: :send_ios_login_email
    get  '/login/ios/:api_key' => 'auth#login_on_ios',         as: :login_on_ios
  end

  resource :profile, only: [:show]

  resources :teams, only: [:index, :show, :edit, :update]

  get   '/staff'           => 'teams#staff'
  post  '/slack/sync'      => 'teams#sync', as: :sync_slack
  patch '/profile/api_key' => 'profiles#reset_api_key', as: :reset_api_key

  root to: redirect('/staff')
end
