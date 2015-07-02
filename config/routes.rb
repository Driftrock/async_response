AsyncResponse::Engine.routes.draw do
  root to: 'responses#index'
  resources :responses, only: [:index, :show, :destroy]
end
