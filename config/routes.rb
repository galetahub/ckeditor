Rails.application.routes.draw do
  namespace :ckeditor, :only => [:index, :create, :destroy] do
    resources :pictures
    resources :attachment_files
  end
end
