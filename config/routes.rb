Rails.application.routes.draw do
  root "spreads#index"
  resources :spreads, only: [:index]
  resources :spread_alerts, only: [:index, :create] do
    get :pooling, on: :collection
  end

end
