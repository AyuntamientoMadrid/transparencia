Rails.application.routes.draw do
  root 'home#index'
  resources :areas, only: [:index]
  resources :departments, only: [:show]
  resources :objectives, only: [:show, :edit, :update] 
end