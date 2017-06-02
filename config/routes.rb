Rails.application.routes.draw do
  devise_for :administrators, {
    skip: [:registrations]
  }

  root 'people#councillors'

  resources :areas, only: [:index] do
    resources :departments, only: [:index]
  end

  resources :departments, only: [:show]
  resources :objectives, only: [:show, :edit, :update]
  resources :pages
  resources :people do
    member do
      post :contact
      put :hide
      put :unhide
    end
    collection do
      get :councillors
      get :directors
      get :temporary_workers
    end
  end
  resources :subventions
  resources :contracts

  resources :searches, only: :index

  get "designs/enquiry_index", to: "designs#enquiry_index"
  get "designs/enquiry_form", to: "designs#enquiry_form"
  get "designs/enquiry_show", to: "designs#enquiry_show"

  namespace :admin do
    root to: "dashboard#index"
    resources :profile_uploads, only: [:new, :create, :show, :index]
    resources :activities_uploads, only: [:new, :create, :show, :index]
    resources :people, only: [:index]
  end

  # static pages
  get "/accessibility", to: "static_pages#accessibility"
  get "/conditions", to: "static_pages#conditions"
  get "/privacy", to: "static_pages#privacy"

end
