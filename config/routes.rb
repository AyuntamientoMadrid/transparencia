Rails.application.routes.draw do
  root 'home#index'

  get "designs/enquiry_index", to: "designs#enquiry_index"
  get "designs/enquiry_form", to: "designs#enquiry_form"
  get "designs/enquiry_show", to: "designs#enquiry_show"
end
