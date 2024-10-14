class MgHealthTest < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_checkup_particular)
  belongs_to(:mg_employee)
  belongs_to(:mg_check_up_schedules)
  belongs_to(:mg_student)
end
