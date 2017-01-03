Rails.application.routes.draw do
  resources :performance_set_dates
  captcha_route
  resources :absences do
    member do
      put :flip_excused_flag, as: :flip_excused_flag
      patch :set_sub, as: :set_sub
    end
  end
  resources :member_notes
  resources :action_logs
  devise_for :users
  resources :set_member_instruments
  resources :performance_sets do
    member do
      get :rehearsal_dates
      get :roster, as: :roster
    end
  end
  resources :ensembles
  resources :member_instruments
  resources :members do
    member do
      get :send_email
    end
  end
  resources :performance_pieces
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
