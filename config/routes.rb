# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  authenticated :user do
    root to: "authorized_dashboard#show", as: :authenticated_root
  end

  scope 'hired' do
    get 'challenge', to: 'challenges#new', as: 'new_challenge'
    post 'challenges', to: 'challenges#create', as: 'challenges'
    get 'challenges/:id', to: 'challenges#show', as: 'challenge'

    post 'gql', to: 'challenges/registrations#create'
    get 'challenge/report/:id', to: 'challenges/reports#show', as: 'report'
  end

  root to: "dashboard#show"
end
