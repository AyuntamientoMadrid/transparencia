Rails.application.routes.draw do
  resources :areas, only: [:index]
  resources :departments, only: [:show]
  resources :objectives, only: [:show, :edit, :update] 
end