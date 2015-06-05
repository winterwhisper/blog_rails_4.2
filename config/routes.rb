Rails.application.routes.draw do
  namespace :admin, path: :console do
    resources :posts, except: [:show]
    resources :comments, only: [:index, :destroy]
    resources :tags, except: [:show]

    resource :sessions, only: [:new, :create, :destroy]
    controller :sessions do
      get :login, to: :new
      post :login, to: :create
      delete :logout, to: :destroy
    end
  end
end
