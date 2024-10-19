 get 'classes', to:'classes#index'
 resources :classes do
    member do
      delete :delete
      get 'batchList', to: 'classes#batcheList'
    end
  end
