Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    
    resources :users do
      member do
        get :following, to: "follows#following"
        get :followers, to: "follows#followers"
        get :bookmarking, to: "bookmarks#index"
      end
    end
    resources :relationships, only: %i(create destroy)
    resources :posts, except: :index do
      member do
        get :likers, to: "likes#index"
      end
    end
    resources :likes, :bookmarks, only: %i(create destroy)
  end
end
