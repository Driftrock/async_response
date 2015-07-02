Rails.application.routes.draw do
  mount AsyncResponse::Engine => "/async_response"
  resources :projects, only: [:index]
end
