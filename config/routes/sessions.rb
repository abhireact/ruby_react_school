delete 'logout', to: 'sessions#destroy', as: 'logout'
get 'log_in' => 'sessions#index', :as => 'log_in'
post 'sessions/forgot_password'
post 'sessions/update_password'
post 'sessions/create'
get 'sessions/change_school' => 'sessions#change_school', as: :change_school
resources :sessions
