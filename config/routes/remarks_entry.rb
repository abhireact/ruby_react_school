get 'remarks_entry/index', to: 'remarks_entry#index'

get 'remarks_entry/show_remarks_entry', to: 'remarks_entry#show_remarks_entry', as:'show_remarks_entry'

post '/remarks_entry/create_remarks_entry', to: 'remarks_entry#create_remarks_entry' , as: 'create_remarks_entry'

patch '/remarks_entry/update_remarks_entry/:id', to: 'remarks_entry#update_remarks_entry', as: 'update_remarks_entry'

delete '/remarks_entry/delete_remarks_entry/:id', to: 'remarks_entry#delete_remarks_entry', as: 'delete_remarks_entry'

resources :remarks_entry