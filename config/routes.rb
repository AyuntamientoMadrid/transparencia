Rails.application.routes.draw do
  devise_for :administrators, {
    skip: [:registrations]
  }

  root 'home#index'

  resources :areas, only: [:index] do
    resources :departments, only: [:index]
  end
  resources :departments, only: [:show]
  resources :objectives, only: [:show, :edit, :update]
  resources :pages
  resources :people, only: [:index, :show] do
    member { post :contact }
  end

  get "designs/enquiry_index", to: "designs#enquiry_index"
  get "designs/enquiry_form", to: "designs#enquiry_form"
  get "designs/enquiry_show", to: "designs#enquiry_show"

  namespace :admin do
    root to: "dashboard#index"

    resource :stats, only: :show

    namespace :api do
      resource :stats, only: :show
    end
  end

end
