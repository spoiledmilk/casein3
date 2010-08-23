Rails.application.routes.draw do
  
  namespace :casein do
    resources :users do
      member do
        put :update_password, :reset_password
      end
    end
    resource :auth, :controller => :auth do
      post :login, :recover_password
      get :logout
    end
    get :blank, :controller => :casein
    root :to => "casein#index"
  end
  
end