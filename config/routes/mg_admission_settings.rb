  post 'mg_admission_settings/new'
  post 'mg_admission_settings/update'
  get 'mg_admission_settings/show'
  get 'mg_admission_settings/admission_setting_detail'

get 'mg_admission_settings/admission_setting_detail/:id', to: 'mg_admission_settings#admission_setting_detail'
get 'mg_admission_settings/admission_setting_detail_create'
post 'mg_admission_settings/admission_setting_detail_create'
resources :mg_admission_settings