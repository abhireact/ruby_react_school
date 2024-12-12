get 'upload_excel_set_one/index', to: 'upload_excel_set_one#index'
get 'upload_excel_set_one/wings', to: 'upload_excel_set_one#wings'
get 'upload_excel_set_one/class', to: 'upload_excel_set_one#class'
get 'upload_excel_set_one/section', to: 'upload_excel_set_one#section'
get 'upload_excel_set_one/accounts', to: 'upload_excel_set_one#accounts'

get 'upload_excel_set_one/template1_exists', to: 'upload_excel_set_one#template1_exists', as: 'template1_exists'

post '/upload_excel_set_one/upload_academics', to: 'upload_excel_set_one#upload_academics', as: 'upload_academics'
post '/upload_excel_set_one/upload_wings', to: 'upload_excel_set_one#upload_wings', as: 'upload_wings'

post '/upload_excel_set_one/upload_class', to: 'upload_excel_set_one#upload_class', as: 'upload_class'
post '/upload_excel_set_one/upload_section', to: 'upload_excel_set_one#upload_section', as: 'upload_section'
post '/upload_excel_set_one/upload_accounts', to: 'upload_excel_set_one#upload_accounts', as: 'upload_accounts'



resources :upload_excel_set_one