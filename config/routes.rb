Rails.application.routes.draw do

  root to: 'pages#new'

  get 'game', to: 'pages#game', as: :game

  get 'score', to: 'pages#score', as: :score

  get 'new', to: 'pages#new', as: :new

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
