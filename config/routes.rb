# frozen_string_literal: true

Rails.application.routes.draw do
  resources :daily_menus, only: :index
end
