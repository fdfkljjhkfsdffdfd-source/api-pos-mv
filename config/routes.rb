Rails.application.routes.draw do

  resources :receipt_items do
    collection do
      get :receipt_items_by_receipt
    end
  end


  resources :receipts do
    member do
      get :receipt_preview  
      get :receipt_pdf  
      get :static_pdf
    end
  end



  resources :cart_items
  resources :carts

  resources :sku_masters do
    collection do
      get :search
      get :by_category
      get :sku_master_pagination
    end
  end

  resources :categories


  resources :users do
    collection do
      get :search
      get :roles
    end
  end


  post "/login", to: "auth#login"
  post "/login/admin", to: "auth#login_admin"
  get '/cart_by_user/:user_id', to: 'carts#cart_by_user'
  post '/payments/cash', to: 'payments#cash'
  




end
