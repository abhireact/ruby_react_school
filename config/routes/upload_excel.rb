get 'upload_excel/upload_file', to: 'upload_excel#upload_file', as: 'upload_file'


get 'upload_excel/employee_department', to: 'upload_excel#employee_department'
get 'upload_excel/employee_profile', to: 'upload_excel#employee_profile'
get 'upload_excel/employee_type', to: 'upload_excel#employee_type'
get 'upload_excel/template_two', to: 'upload_excel#template_two', as: 'template_two'
get 'upload_excel/employee_data_exists', to: 'upload_excel#employee_data_exists', as: 'employee_data_exists'


get 'upload_excel/employee_grades', to: 'upload_excel#employee_grades'
get 'upload_excel/employee_leaves', to: 'upload_excel#employee_leaves'
get 'upload_excel/employee_salary', to: 'upload_excel#employee_salary'

post '/upload_excel/upload_departments', to: 'upload_excel#upload_departments', as: 'upload_departments'
post '/upload_excel/upload_positions', to: 'upload_excel#upload_positions', as: 'upload_positions'
post '/upload_excel/upload_employee_types', to: 'upload_excel#upload_employee_types', as: 'upload_employee_types'
post '/upload_excel/upload_employee_leave_types', to: 'upload_excel#upload_employee_leave_types', as: 'upload_employee_leave_types'
post '/upload_excel/upload_assign_class_teacher', to: 'upload_excel#upload_assign_class_teacher', as: 'upload_assign_class_teacher'

post '/upload_excel/upload_salary', to: 'upload_excel#upload_salary', as: 'upload_salary'
post '/upload_excel/upload_leaves', to: 'upload_excel#upload_leaves', as: 'upload_leaves'
post '/upload_excel/upload_employees', to: 'upload_excel#upload_employees', as: 'upload_employees'
post '/upload_excel/upload_grades', to: 'upload_excel#upload_grades', as: 'upload_grades'
post '/upload_excel/validate_employees', to: 'upload_excel#validate_employees', as: 'validate_employees'

resources :upload_excel
