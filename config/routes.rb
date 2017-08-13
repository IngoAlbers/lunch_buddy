# frozen_string_literal: true

Rails.application.routes.draw do
  root 'restaurant/daily_menus#index'

  namespace :restaurant do
    resources :daily_menus, only: :index
  end
end
