Rails.application.routes.draw do
  namespace :admin, path: :console do
    resources :posts, except: [:show]
  end
end
