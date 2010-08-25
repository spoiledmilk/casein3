Rails.application.routes.draw do
  
  match "/admin" => redirect("/casein")
  
  namespace :casein do
    resources :users do
      member do
        put :update_password, :reset_password
      end
    end
    
    resource :user_session
    resource :password_reset, :only => [:create, :edit, :update]
        
    get :blank, :controller => :casein
    root :to => "casein#index"
  end
  
end