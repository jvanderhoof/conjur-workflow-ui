Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :databases
  resources :projects
  resources :grants, only: [:new, :create]
end
