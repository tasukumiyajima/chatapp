Rails.application.routes.draw do
  root 'rooms#index'
  get "/update_check", to: "rooms#update_check"
  get "/show_additionally", to: "rooms#show_additionally"
  get '/search', to: 'rooms#search'

  resources :rooms, only: [:index, :new, :show, :create] do
    resources :messages, only: [:create]
  end

  namespace :api, { format: 'json' } do
    resources :emojis, only: :index
  end

  mount ActionCable.server => "/cable"

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
  }

  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
  end
end
