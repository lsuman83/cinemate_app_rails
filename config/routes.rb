Rails.application.routes.draw do
 
  resources :movies
  resources :watch_lists do
    resources :watch_list_movies 
    get "/watch_list_movies/:genre_slug", to: "watch_list_movies#genres" 
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "welcome#home"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
