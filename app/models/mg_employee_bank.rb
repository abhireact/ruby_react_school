class MgEmployeeBank < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_bank_detail)
end
