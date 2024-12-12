get 'upload_excel_set_four/index', to: 'upload_excel_set_four#index'
get 'upload_excel_set_four/fee_data_exists', to: 'upload_excel_set_four#fee_data_exists', as: 'fee_data_exists'

post '/upload_excel_set_four/upload_fee_category', to: 'upload_excel_set_four#upload_fee_category', as: 'upload_fee_category'
post '/upload_excel_set_four/upload_fee_particular', to: 'upload_excel_set_four#upload_fee_particular', as: 'upload_fee_particular'
post '/upload_excel_set_four/upload_fee_discount', to: 'upload_excel_set_four#upload_fee_discount', as: 'upload_fee_discount'
post '/upload_excel_set_four/upload_late_fee_fine', to: 'upload_excel_set_four#upload_late_fee_fine', as: 'upload_late_fee_fine'
resources :upload_excel_set_four