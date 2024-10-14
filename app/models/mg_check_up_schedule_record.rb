class MgCheckUpScheduleRecord < ApplicationRecord
  belongs_to(:mg_check_up_schedule)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_employee_department)
end
