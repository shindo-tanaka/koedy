Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts, only: [:index] do
    collection do
      get :search
    end
  end
  
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end

  get 'users/like' => 'users#like'
  resources :maps
  root 'posts#top'
end
