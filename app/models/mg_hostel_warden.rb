class MgHostelWarden < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_user)
end
