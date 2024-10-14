class MgAttendanceFinalizeTime < ApplicationRecord
  belongs_to(:mg_time_table)
  belongs_to(:mg_course)
  belongs_to(:mg_batch)
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
end
