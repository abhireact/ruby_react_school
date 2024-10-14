class MgEmployeeSubject < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
end
