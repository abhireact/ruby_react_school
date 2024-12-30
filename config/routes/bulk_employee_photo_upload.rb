get 'bulk_employee_photo_upload/index', to: 'bulk_employee_photo_upload#index'


post '/bulk_employee_photo_upload/bulk_photo_upload', to: 'bulk_employee_photo_upload#bulk_photo_upload' , as: 'bulk_photo_upload'


resources :bulk_employee_photo_upload