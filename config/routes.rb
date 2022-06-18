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

  # Kiosks
  get("/kiosks/:id", to: "kiosks#show", as: :show_kiosk)
  get("/kiosks", to: "kiosks#new", as: :new_kiosk)
  post("/kiosks", to: "kiosks#create", as: :create_kiosk)
  delete("/kiosks", to: "kiosks#destroy", as: :destroy_kiosk)

  # Purchases
  post("/cart", to: "purchases#create", as: :create_cart)
  get("/cart", to: "purchases#edit", as: :edit_cart)
  patch("/cart", to: "purchases#update", as: :update_cart)
  delete("/cart", to: "purchases#destroy", as: :destroy_cart)
  
  # Orders
  get("/orders", to: "orders#index", as: :index_order)
  get("/orders/:id", to: "orders#show", as: :show_order)

  # Products
  get("/foods-and-beverages", to: "products#new", as: :new_product)
  post("/foods-and-beverages", to: "products#create", as: :create_product)
  delete("/foods-and-beverages", to: "products#destroy", as: :destroy_product)

  # Menus
  get("/menus", to: "menus#new", as: :new_menu)
  post("/menus", to: "menus#create", as: :create_menu)
  delete("/menus", to: "menus#destroy", as: :destroy_menu)

  # API
  get("/api", to: "apis#index", as: :api)
  post("/api", to: "apis#index", as: :api_post)
end
