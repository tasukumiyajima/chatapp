Rails.application.routes.draw do
  root 'rooms#index'
  resources :rooms, only: [:index, :new, :show, :create] do
    resources :messages, only: [:create]
  end
  get '/search', to: 'rooms#search'

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
