class MgFinanceOfficer < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
  belongs_to(:mg_employee_department)
end
