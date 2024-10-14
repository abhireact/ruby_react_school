class MgEmployeeGradeComponent < ApplicationRecord
  belongs_to(:mg_School)
  belongs_to(:mg_employee)
  belongs_to(:mg_salary_component)
end
