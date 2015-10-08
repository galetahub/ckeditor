Rails.application.routes.draw do
  resources :posts
  root to: "posts#index"

  mount Ckeditor::Engine, at: '/ckeditor'
end
