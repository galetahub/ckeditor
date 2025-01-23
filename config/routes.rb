# frozen_string_literal: true

Ckeditor::Engine.routes.draw do
  resources :pictures, only: %i[index create destroy]
  resources :attachment_files, only: %i[index create destroy]
end
