Rails.application.routes.draw do
  resources :member_community_nights
  resources :community_nights
  resources :emails do
    member do
      get :send_email
    end
  end
  resources :performance_set_dates
  captcha_route
  resources :absences do
    member do
      put :flip_excused_flag, as: :flip_excused_flag
      patch :set_sub, as: :set_sub
    end
    collection do
      get :record_attendance
      post :batch_create
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
      get :email_roster, as: :email_roster
    end
  end
  resources :ensembles
  resources :member_instruments
  resources :members do
    member do
      get :send_email
    end
    collection do
      get :requires_sub_name
      get :get_filtered_member_info
    end
  end
  resources :performance_pieces
  resources :users
  resources :performance_set_instruments

  resources :member_sets, only: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end
