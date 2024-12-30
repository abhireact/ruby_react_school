get 'employee_archive/index', to: 'employee_archive#index'

post 'employee_archive/archive_employee', to: 'employee_archive#archive_employee', as: 'archive_employee'
post 'employee_archive/unarchive_employee/:id', to: 'employee_archive#unarchive_employee', as: 'unarchive_employee'

patch 'employee_archive/update_archive_employee/:id', to: 'employee_archive#update_archive_employee', as: 'update_archive_employee'

get 'employee_archive/show_archive_employees', to: 'employee_archive#show_archive_employees', as: 'show_archive_employees'

resources :employee_archive
