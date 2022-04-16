Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root("application#index")

  # Sign Up
  get("/auth/sign-up", to: "users#new", as: :new_user)
  post("/auth/sign-up", to: "users#create", as: :create_user)

  # Sign In
  get("/auth/sign-in", to: "sessions#new", as: :new_session)
  post("/auth/sign-in", to: "sessions#create", as: :create_session)
  delete("/auth/sign-out", to: "sessions#destroy", as: :destroy_session)
end
