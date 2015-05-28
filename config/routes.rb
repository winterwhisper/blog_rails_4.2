Rails.application.routes.draw do
  namespace :admin, path: :console do
    resources :posts, except: [:show]
    resources :comments, only: [:index, :destroy]
    resources :tags, except: [:show]
  end
end
