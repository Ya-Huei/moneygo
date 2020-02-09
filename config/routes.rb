Rails.application.routes.draw do
  devise_for :users
  resources :keyword_mappings
  post '/chat/webhook', to: 'chat#webhook'
end
