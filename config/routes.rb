Rails.application.routes.draw do
  resources :watch_lists
  devise_for :users
  root "watch_lists#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
