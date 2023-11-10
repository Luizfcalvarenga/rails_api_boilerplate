Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }

	require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

	namespace :api, defaults: { format: :json } do
    namespace :v1 do
			mount_devise_token_auth_for 'User', at: 'auth'
      get 'users/me', to: 'users#me'
			get 'users/:id', to: 'users#show'
		end
  end
end
