Rails.application.routes.draw do
  namespace :admin, path: :console do
    resources :posts, except: [:show]
    resources :comments, only: [:index, :destroy]
    resources :tags, except: [:show]

    resource :sessions, only: [:new, :create, :destroy]
    controller :sessions do
      get :sign_in, to: :new
      post :sign_in, to: :create
      delete :sign_out, to: :destroy
    end
  end
end
