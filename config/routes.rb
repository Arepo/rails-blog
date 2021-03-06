Rails.application.routes.draw do
  # TODO get friendly IDs

  get 'sessions/new'

  get 'post/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts

  get 'filter_posts' => 'posts#filter_posts'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  root 'posts#index'
end
