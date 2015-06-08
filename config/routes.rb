Rails.application.routes.draw do
  # 前台
  resources :posts, only: [:show]

  # 后台
  namespace :admin, path: :console do
    root to: 'dashboard#home'
    resources :posts, except: [:show]
    resources :comments, only: [:index, :destroy]
    resources :tags, except: [:show]
    resources :users
    resources :admins, only: [:show, :edit, :update]
    controller :admins do
      get :profile, action: :show
      get 'profile/edit', action: :edit
      put :profile, action: :update
      patch :profile, action: :update
    end

    resource :sessions, only: [:new, :create, :destroy]
    controller :sessions do
      get :login, action: :new
      post :login, action: :create
      delete :logout, action: :destroy
    end
    resource :change_passwords, only: [:new, :create],
                                path_names: { new: '' },
                                path: :change_password
    resource :searchs, only: [:show], path: :search

    controller :dashboard do
      get :home, action: :home
    end
  end
end
