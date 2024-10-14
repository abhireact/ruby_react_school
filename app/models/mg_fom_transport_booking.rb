class MgFomTransportBooking < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_employee_category)
  belongs_to(:mg_employee_position)
end
