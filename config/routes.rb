Rails.application.routes.draw do
  namespace :admin, path: :console do
    root to: 'dashboard#home'
    resources :posts, except: [:show]
    resources :comments, only: [:index, :destroy]
    resources :tags, except: [:show]

    resource :sessions, only: [:new, :create, :destroy]
    controller :sessions do
      get :login, action: :new
      post :login, action: :create
      delete :logout, action: :destroy
    end

    controller :dashboard do
      get :home, action: :home
    end
  end
end
