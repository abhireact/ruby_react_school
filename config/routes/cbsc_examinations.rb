 get 'cbsc_examinations', to:'cbsc_examinations#index'
 resources :cbsc_examinations do
    member do
      delete :delete
    end
  end