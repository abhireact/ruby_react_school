class MgGradeComponent < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_grade)
  belongs_to(:mg_salary_component)
end
