Rails.application.routes.draw do
  root 'welcome#home'
  resources :areas, only: [:index]
  resources :departments, only: [:show]
  resources :objectives, only: [:show, :edit, :update] 
end