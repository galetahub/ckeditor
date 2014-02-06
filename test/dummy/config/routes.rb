Dummy::Application.routes.draw do
  resources :posts
  root :to => "posts#index"

  mount Ckeditor::Engine => '/ckeditor'
end
