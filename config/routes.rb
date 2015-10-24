Rails.application.routes.draw do
  root 'welcome#home'
  resources :areas, only: [:index] do
    resources :departments, only: [:index]  
  end
  resources :departments, only: [:show]
  resources :objectives, only: [:show, :edit, :update] 
end