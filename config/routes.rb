Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } # Google Omniauth
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update]

  resources :meetings do
    collection do
      get 'upcoming'
      get 'past'
    end
    member do
      get 'copy_invite' # User's page to copy invite to Invitee
      get 'send_invite' # Invite's page to confirm invite
      get 'meeting_confirmation' # Confirmation after invitee enters email
    end
  end
end
