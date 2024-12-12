get 'sub_subject/index', to: 'sub_subject#index'
get 'sub_subject/show_sub_subjects', to: 'sub_subject#show_sub_subjects', as:'show_sub_subjects'

post '/sub_subject/create_sub_subject', to: 'sub_subject#create_sub_subject', as: 'create_sub_subject'


patch '/sub_subject/update_sub_subject/:id', to: 'sub_subject#update_sub_subject', as: 'update_sub_subject'


delete '/sub_subject/delete_sub_subject/:id', to: 'sub_subject#delete_sub_subject', as: 'delete_sub_subject'

resources :sub_subject