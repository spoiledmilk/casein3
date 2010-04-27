Rails.application.routes.draw do |map|
  namespace :casein do
    resources :users
    resource :auth, :controller => :auth do
      post :login, :recover_password
      get :logout
    end
  end
end