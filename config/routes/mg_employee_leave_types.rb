get 'mg_employee_leave_types/ leave_action_save'=>'mg_employee_leave_types#leave_action_save',as: :leave_action_save
  get 'mg_employee_leave_types/leave_action'=>'mg_employee_leave_types#leave_action',as: :leave_action
  get 'mg_employee_leave_types/leave_for_approve'=>'mg_employee_leave_types#leave_for_approve',as: :leave_for_approve
   get 'mg_employee_leave_types/validate_employee_leave'=>'mg_employee_leave_types#validate_employee_leave', os: :validate_employee_leave
get 'mg_employee_leave_types/delete/:id' => 'mg_employee_leave_types#delete'
  get 'mg_employee_leave_types/from_emp'=>'mg_employee_leave_types#from_emp', as: :from_emp
  get 'mg_employee_leave_types/search'
  get '/mg_employee_leave_types/emp_attendances' => 'mg_employee_leave_types#emp_attendances', as: :emp_attendances
  get '/mg_employee_leave_types/employee_leave'
  get '/mg_employee_leave_types/for_manager_attendence'
  get '/mg_employee_leave_types/approve_leave_by_manager/:id' => 'mg_employee_leave_types#approve_leave_by_manager'
  get '/mg_employee_leave_types/is_not_approve/:id' => 'mg_employee_leave_types#is_not_approve'
  get '/mg_employee_leave_types/is_approve/:id' => 'mg_employee_leave_types#is_approve'
  get '/mg_employee_leave_types/department_reset/:id' => 'mg_employee_leave_types#department_reset'
  get '/mg_employee_leave_types/individual_employee_leave_reset' #=> 'mg_employee_leave_types#individual_employee_leave_reset'
  resources :mg_employee_leave_types
