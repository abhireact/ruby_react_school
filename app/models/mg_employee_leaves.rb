class MgEmployeeLeaves < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
end
