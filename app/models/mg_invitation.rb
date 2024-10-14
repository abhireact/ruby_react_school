class MgInvitation < ApplicationRecord
  belongs_to(:mg_event)
  belongs_to(:mg_wing)
  belongs_to(:mg_batch)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_school)
end
