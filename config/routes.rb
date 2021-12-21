Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } # Google Omniauth
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: :show

  resources :meetings do
    collection do
      get 'upcoming'
      get 'past'
    end
    member do
      get 'send_invite' # to send external link to attendee
    end
  end
end
