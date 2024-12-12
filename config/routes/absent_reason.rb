get 'absent_reason/index', to: 'absent_reason#index'

get 'absent_reason/show_absent_reasons', to: 'absent_reason#show_absent_reasons', as:'show_absent_reasons'

post '/absent_reason/create_absent_reason', to: 'absent_reason#create_absent_reason' , as: 'create_absent_reason'

patch '/absent_reason/update_absent_reason/:id', to: 'absent_reason#update_absent_reason', as: 'update_absent_reason'

delete '/absent_reason/delete_absent_reason/:id', to: 'absent_reason#delete_absent_reason', as: 'delete_absent_reason'

resources :absent_reason