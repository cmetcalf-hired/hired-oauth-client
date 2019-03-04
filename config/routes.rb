# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }


  authenticated :user do
    root to: "authorized_dashboard#show", as: :authenticated_root
  end

  root to: "dashboard#show"
end
