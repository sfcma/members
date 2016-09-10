Rails.application.routes.draw do
  resources :absences
  resources :member_notes
  resources :action_logs
  devise_for :users
  resources :set_member_instruments
  resources :performance_sets
  resources :performances
  resources :member_instruments
  resources :members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
