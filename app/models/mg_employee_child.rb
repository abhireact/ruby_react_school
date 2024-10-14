class MgEmployeeChild < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_user)
  belongs_to(:mg_employee)
end
