get 'addmissions/edit'
get 'addmissions/wing_update/:id' => 'addmissions#wing_update'
get 'addmissions/show'
get 'addmissions/index', to: 'addmissions#index'

get 'addmissions/admission_setting_detail/:id', to: 'addmissions#admission_setting_detail'
resources :addmissions